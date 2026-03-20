package com.gigshield.dto;

import lombok.*;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DashboardStats {
    private long totalWorkers;
    private long activeWorkers;
    private long activePolicies;
    private long totalClaims;
    private long pendingClaims;
    private long fraudFlagged;
    private BigDecimal totalPremiumCollected;
    private BigDecimal totalPayouts;
    private long activeDisruptions;
}
