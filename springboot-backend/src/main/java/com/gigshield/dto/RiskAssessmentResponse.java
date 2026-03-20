package com.gigshield.dto;

import lombok.*;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RiskAssessmentResponse {
    private double riskScore;
    private BigDecimal weeklyPremium;
    private BigDecimal coverageAmount;
    private String riskLevel;
    private String[] riskFactors;
}
