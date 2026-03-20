package com.gigshield.service;

import com.gigshield.dto.FraudCheckResponse;
import com.gigshield.dto.RiskAssessmentResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.math.BigDecimal;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class AIServiceClient {

    private final WebClient.Builder webClientBuilder;

    @Value("${gigshield.ai-service.url:http://localhost:8000}")
    private String aiServiceUrl;

    /**
     * Call AI service for risk assessment and premium calculation.
     */
    public RiskAssessmentResponse assessRisk(String city, String zone, double avgDailyIncome, int workingHours) {
        log.info("Requesting risk assessment for city: {}, zone: {}", city, zone);

        try {
            return webClientBuilder.build()
                    .post()
                    .uri(aiServiceUrl + "/api/risk/assess")
                    .bodyValue(Map.of(
                            "city", city,
                            "zone", zone,
                            "avg_daily_income", avgDailyIncome,
                            "working_hours", workingHours
                    ))
                    .retrieve()
                    .bodyToMono(RiskAssessmentResponse.class)
                    .block();
        } catch (Exception e) {
            log.error("AI service call failed, using fallback", e);
            return fallbackRiskAssessment(avgDailyIncome);
        }
    }

    /**
     * Call AI service for fraud detection.
     */
    public FraudCheckResponse checkFraud(String userId, String disruptionType,
                                          Double userLat, Double userLon,
                                          Double disruptionLat, Double disruptionLon) {
        log.info("Requesting fraud check for user: {}", userId);

        try {
            return webClientBuilder.build()
                    .post()
                    .uri(aiServiceUrl + "/api/fraud/check")
                    .bodyValue(Map.of(
                            "user_id", userId,
                            "disruption_type", disruptionType,
                            "user_lat", userLat != null ? userLat : 0,
                            "user_lon", userLon != null ? userLon : 0,
                            "disruption_lat", disruptionLat != null ? disruptionLat : 0,
                            "disruption_lon", disruptionLon != null ? disruptionLon : 0
                    ))
                    .retrieve()
                    .bodyToMono(FraudCheckResponse.class)
                    .block();
        } catch (Exception e) {
            log.error("Fraud check service call failed, using fallback", e);
            return FraudCheckResponse.builder()
                    .isFraudulent(false)
                    .fraudScore(0.0)
                    .reason("Fraud service unavailable — defaulting to non-fraudulent")
                    .flags(new String[]{})
                    .build();
        }
    }

    /**
     * Fallback risk assessment when AI service is unavailable.
     */
    private RiskAssessmentResponse fallbackRiskAssessment(double avgDailyIncome) {
        double riskScore = 0.5;
        double weeklyPremium = avgDailyIncome * 7 * 0.005;
        double coverageAmount = avgDailyIncome * 7 * 0.15;

        return RiskAssessmentResponse.builder()
                .riskScore(riskScore)
                .weeklyPremium(BigDecimal.valueOf(weeklyPremium))
                .coverageAmount(BigDecimal.valueOf(coverageAmount))
                .riskLevel("medium")
                .riskFactors(new String[]{"Fallback assessment — AI service unavailable"})
                .build();
    }
}
