package com.gigshield.service;

import com.gigshield.dto.DashboardStats;
import com.gigshield.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
public class DashboardService {

    private final UserRepository userRepository;
    private final PolicyRepository policyRepository;
    private final ClaimRepository claimRepository;
    private final DisruptionRepository disruptionRepository;
    private final TransactionRepository transactionRepository;

    public DashboardStats getDashboardStats() {
        BigDecimal totalPremium = transactionRepository.getTotalPremiumCollected();
        BigDecimal totalPayouts = transactionRepository.getTotalPayoutsCompleted();

        return DashboardStats.builder()
                .totalWorkers(userRepository.count())
                .activeWorkers(userRepository.countByIsActiveTrue())
                .activePolicies(policyRepository.countByStatus("active"))
                .totalClaims(claimRepository.count())
                .pendingClaims(claimRepository.countByClaimStatus("pending"))
                .fraudFlagged(claimRepository.countFraudFlagged())
                .totalPremiumCollected(totalPremium != null ? totalPremium : BigDecimal.ZERO)
                .totalPayouts(totalPayouts != null ? totalPayouts : BigDecimal.ZERO)
                .activeDisruptions(disruptionRepository.countByIsActiveTrue())
                .build();
    }
}
