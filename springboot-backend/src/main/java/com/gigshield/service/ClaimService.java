package com.gigshield.service;

import com.gigshield.model.Claim;
import com.gigshield.model.Disruption;
import com.gigshield.model.Policy;
import com.gigshield.model.User;
import com.gigshield.repository.ClaimRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class ClaimService {

    private final ClaimRepository claimRepository;
    private final NotificationService notificationService;

    @Transactional
    public Claim createAutoClaim(User user, Policy policy, Disruption disruption, BigDecimal lostHours) {
        log.info("Creating auto-claim for user: {} due to: {}", user.getId(), disruption.getType());

        // Calculate hourly rate from daily income and working hours
        BigDecimal hourlyRate = user.getAvgDailyIncome()
                .divide(BigDecimal.valueOf(user.getWorkingHours()), 2, RoundingMode.HALF_UP);

        // Calculate payout amount (lost_hours * hourly_rate)
        BigDecimal payoutAmount = lostHours.multiply(hourlyRate).setScale(2, RoundingMode.HALF_UP);

        // Cap payout at coverage limit
        if (payoutAmount.compareTo(policy.getCoverageLimit()) > 0) {
            payoutAmount = policy.getCoverageLimit();
        }

        // Check for 30-day waiting period
        java.time.OffsetDateTime thirtyDaysAgo = java.time.OffsetDateTime.now().minusDays(30);
        boolean isWaitingPeriod = user.getCreatedAt().isAfter(thirtyDaysAgo);

        String initialStatus = isWaitingPeriod ? "rejected" : "pending";
        BigDecimal initialFraudScore = isWaitingPeriod ? BigDecimal.valueOf(100) : BigDecimal.ZERO;
        String fraudReason = isWaitingPeriod ? "Waiting period of 30 days not completed" : null;

        Claim claim = Claim.builder()
                .user(user)
                .policy(policy)
                .disruption(disruption)
                .disruptionType(disruption.getType())
                .lostHours(lostHours)
                .hourlyRate(hourlyRate)
                .payoutAmount(payoutAmount)
                .claimStatus(initialStatus)
                .fraudScore(initialFraudScore)
                .fraudReason(fraudReason)
                .autoTriggered(true)
                .build();

        Claim saved = claimRepository.save(claim);

        // Send notification
        if (isWaitingPeriod) {
            notificationService.sendNotification(user,
                    "Claim Rejected",
                    String.format("A %s disruption was detected, but your claim was rejected because the 30-day waiting period is not completed.",
                            disruption.getType()),
                    "claim");
        } else {
            notificationService.sendNotification(user,
                    "Claim Auto-Triggered",
                    String.format("A %s disruption was detected in your zone. Claim of ₹%.0f has been initiated.",
                            disruption.getType(), payoutAmount),
                    "claim");
        }

        log.info("Auto-claim created: {} with payout: ₹{}", saved.getId(), payoutAmount);
        return saved;
    }

    @Transactional
    public Claim approveClaim(UUID claimId) {
        Claim claim = claimRepository.findById(claimId)
                .orElseThrow(() -> new RuntimeException("Claim not found: " + claimId));
        claim.setClaimStatus("approved");
        return claimRepository.save(claim);
    }

    @Transactional
    public Claim rejectClaim(UUID claimId, String reason) {
        Claim claim = claimRepository.findById(claimId)
                .orElseThrow(() -> new RuntimeException("Claim not found: " + claimId));
        claim.setClaimStatus("rejected");
        claim.setFraudReason(reason);
        return claimRepository.save(claim);
    }

    @Transactional
    public Claim flagFraud(UUID claimId, BigDecimal fraudScore, String reason) {
        Claim claim = claimRepository.findById(claimId)
                .orElseThrow(() -> new RuntimeException("Claim not found: " + claimId));
        claim.setClaimStatus("fraud_flagged");
        claim.setFraudScore(fraudScore);
        claim.setFraudReason(reason);
        return claimRepository.save(claim);
    }

    @Transactional
    public Claim markPaid(UUID claimId) {
        Claim claim = claimRepository.findById(claimId)
                .orElseThrow(() -> new RuntimeException("Claim not found: " + claimId));
        claim.setClaimStatus("paid");

        notificationService.sendNotification(claim.getUser(),
                "Payout Received",
                String.format("₹%.0f has been credited to your wallet.", claim.getPayoutAmount()),
                "payout");

        return claimRepository.save(claim);
    }

    public Optional<Claim> getClaimById(UUID id) {
        return claimRepository.findById(id);
    }

    public List<Claim> getClaimsByUserId(UUID userId) {
        return claimRepository.findByUserId(userId);
    }

    public List<Claim> getClaimsByStatus(String status) {
        return claimRepository.findByClaimStatus(status);
    }

    public List<Claim> getAllClaims() {
        return claimRepository.findAll();
    }

    public BigDecimal getTotalPaidAmount() {
        BigDecimal total = claimRepository.getTotalPaidAmount();
        return total != null ? total : BigDecimal.ZERO;
    }

    public long countFraudFlagged() {
        return claimRepository.countFraudFlagged();
    }
}
