package com.gigshield.dto;

import lombok.*;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FraudCheckResponse {
    private boolean isFraudulent;
    private double fraudScore;
    private String reason;
    private String[] flags;
}
