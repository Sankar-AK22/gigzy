package com.gigshield.service;

import com.gigshield.dto.PolicyCreateRequest;
import com.gigshield.model.Policy;
import com.gigshield.model.User;
import com.gigshield.repository.PolicyRepository;
import com.gigshield.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class PolicyService {

    private final PolicyRepository policyRepository;
    private final UserRepository userRepository;

    @Transactional
    public Policy createWeeklyPolicy(PolicyCreateRequest request) {
        log.info("Creating weekly policy for user: {}", request.getUserId());

        User user = userRepository.findById(UUID.fromString(request.getUserId()))
                .orElseThrow(() -> new RuntimeException("User not found: " + request.getUserId()));

        // Check for existing active policy
        List<Policy> activePolicies = policyRepository.findByUserIdAndStatus(user.getId(), "active");
        if (!activePolicies.isEmpty()) {
            log.warn("User {} already has an active policy", user.getId());
            return activePolicies.get(0);
        }

        LocalDate startDate = LocalDate.now();
        LocalDate endDate = startDate.plusDays(7);

        Policy policy = Policy.builder()
                .user(user)
                .premium(request.getPremium())
                .coverageLimit(request.getCoverageLimit())
                .startDate(startDate)
                .endDate(endDate)
                .status("active")
                .riskScore(request.getRiskScore())
                .build();

        Policy saved = policyRepository.save(policy);
        log.info("Policy created: {} for user: {}", saved.getId(), user.getId());
        return saved;
    }

    public Optional<Policy> getPolicyById(UUID id) {
        return policyRepository.findById(id);
    }

    @Transactional
    public Policy renewPolicy(UUID userId) {
        log.info("Renewing policy for user: {}", userId);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found: " + userId));

        List<Policy> activePolicies = policyRepository.findByUserIdAndStatus(user.getId(), "active");
        
        LocalDate startDate;
        BigDecimal premium = BigDecimal.valueOf(150);
        BigDecimal coverageLimit = BigDecimal.valueOf(10000); 

        if (!activePolicies.isEmpty()) {
            Policy currentPolicy = activePolicies.get(0);
            startDate = currentPolicy.getEndDate().plusDays(1);
            premium = currentPolicy.getPremium();
            coverageLimit = currentPolicy.getCoverageLimit();
        } else {
            startDate = LocalDate.now();
        }

        LocalDate endDate = startDate.plusDays(7);

        Policy policy = Policy.builder()
                .user(user)
                .premium(premium)
                .coverageLimit(coverageLimit)
                .startDate(startDate)
                .endDate(endDate)
                .status(startDate.isAfter(LocalDate.now()) ? "pending_active" : "active")
                .riskScore(user.getRiskScore() != null ? user.getRiskScore() : BigDecimal.valueOf(50))
                .build();

        Policy saved = policyRepository.save(policy);
        log.info("Policy renewed: {} for user: {}", saved.getId(), user.getId());
        return saved;
    }

    public List<Policy> getPoliciesByUserId(UUID userId) {
        return policyRepository.findByUserId(userId);
    }

    public List<Policy> getActivePolicies() {
        return policyRepository.findActivePoliciesOnDate(LocalDate.now());
    }

    public List<Policy> getActivePoliciesByCity(String city) {
        return policyRepository.findActivePoliciesByCityOnDate(city, LocalDate.now());
    }

    @Transactional
    public void expireOldPolicies() {
        List<Policy> activePolicies = policyRepository.findByStatus("active");
        LocalDate today = LocalDate.now();

        activePolicies.stream()
                .filter(p -> p.getEndDate().isBefore(today))
                .forEach(p -> {
                    p.setStatus("expired");
                    policyRepository.save(p);
                    log.info("Expired policy: {}", p.getId());
                });
    }

    public BigDecimal getTotalActivePremiums() {
        BigDecimal total = policyRepository.getTotalActivePremiums();
        return total != null ? total : BigDecimal.ZERO;
    }

    public long countActivePolicies() {
        return policyRepository.countByStatus("active");
    }

    public List<Policy> getAllPolicies() {
        return policyRepository.findAll();
    }
}
