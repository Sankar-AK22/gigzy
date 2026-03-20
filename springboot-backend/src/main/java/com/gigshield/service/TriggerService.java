package com.gigshield.service;

import com.gigshield.dto.FraudCheckResponse;
import com.gigshield.dto.RiskAssessmentResponse;
import com.gigshield.model.Disruption;
import com.gigshield.model.Policy;
import com.gigshield.model.User;
import com.gigshield.repository.DisruptionRepository;
import com.gigshield.repository.PolicyRepository;
import com.gigshield.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class TriggerService {

    private final DisruptionRepository disruptionRepository;
    private final PolicyRepository policyRepository;
    private final UserRepository userRepository;
    private final ClaimService claimService;
    private final AIServiceClient aiServiceClient;

    @Value("${gigshield.triggers.rainfall-mm:60.0}")
    private double rainfallThreshold;

    @Value("${gigshield.triggers.temperature-celsius:42.0}")
    private double temperatureThreshold;

    @Value("${gigshield.triggers.aqi-threshold:350}")
    private int aqiThreshold;

    /**
     * Scheduled job that checks for disruptions every 15 minutes.
     * In production, this would poll weather/pollution/traffic APIs.
     */
    @Scheduled(fixedRate = 900000) // 15 minutes
    public void checkForDisruptions() {
        log.info("Running scheduled disruption check...");
        // In production, this would call external APIs
        // For hackathon, disruptions can be manually triggered via API
    }

    /**
     * Process a new disruption event.
     * Identifies affected workers with active policies and creates auto-claims.
     */
    public Disruption processDisruption(Disruption disruption) {
        log.info("Processing disruption: {} in {}", disruption.getType(), disruption.getCity());

        // Save disruption
        Disruption saved = disruptionRepository.save(disruption);

        // Find affected policies in the disruption city
        List<Policy> affectedPolicies = policyRepository.findActivePoliciesByCityOnDate(
                disruption.getCity(), LocalDate.now());

        log.info("Found {} active policies in {}", affectedPolicies.size(), disruption.getCity());

        for (Policy policy : affectedPolicies) {
            User user = policy.getUser();

            // Calculate estimated lost hours based on severity
            BigDecimal lostHours = calculateLostHours(disruption);

            // Check for fraud before creating claim
            try {
                FraudCheckResponse fraudCheck = aiServiceClient.checkFraud(
                        user.getId().toString(),
                        disruption.getType(),
                        user.getLatitude(),
                        user.getLongitude(),
                        disruption.getLatitude(),
                        disruption.getLongitude()
                );

                if (fraudCheck.isFraudulent()) {
                    log.warn("Fraud detected for user: {}. Reason: {}", user.getId(), fraudCheck.getReason());
                    // Still create claim but mark as fraud
                    var claim = claimService.createAutoClaim(user, policy, saved, lostHours);
                    claimService.flagFraud(claim.getId(),
                            BigDecimal.valueOf(fraudCheck.getFraudScore()),
                            fraudCheck.getReason());
                } else {
                    // Create and auto-approve claim
                    var claim = claimService.createAutoClaim(user, policy, saved, lostHours);
                    claimService.approveClaim(claim.getId());
                }
            } catch (Exception e) {
                log.error("Error checking fraud for user: {}", user.getId(), e);
                // Create claim anyway with pending status
                claimService.createAutoClaim(user, policy, saved, lostHours);
            }
        }

        return saved;
    }

    private BigDecimal calculateLostHours(Disruption disruption) {
        return switch (disruption.getSeverity()) {
            case "critical" -> BigDecimal.valueOf(8);
            case "high" -> BigDecimal.valueOf(5);
            case "medium" -> BigDecimal.valueOf(3);
            case "low" -> BigDecimal.valueOf(1);
            default -> BigDecimal.valueOf(2);
        };
    }

    public List<Disruption> getActiveDisruptions() {
        return disruptionRepository.findByIsActiveTrue();
    }

    public List<Disruption> getDisruptionsByCity(String city) {
        return disruptionRepository.findByCity(city);
    }

    public List<Disruption> getAllDisruptions() {
        return disruptionRepository.findAll();
    }

    public Disruption endDisruption(java.util.UUID disruptionId) {
        Disruption disruption = disruptionRepository.findById(disruptionId)
                .orElseThrow(() -> new RuntimeException("Disruption not found: " + disruptionId));
        disruption.setIsActive(false);
        disruption.setEndedAt(OffsetDateTime.now());
        return disruptionRepository.save(disruption);
    }
}
