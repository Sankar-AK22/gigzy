package com.gigshield.dto;

import lombok.*;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PolicyCreateRequest {
    private String userId;
    private BigDecimal premium;
    private BigDecimal coverageLimit;
    private BigDecimal riskScore;
}
