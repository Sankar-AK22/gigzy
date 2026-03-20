package com.gigshield.model;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "claims")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Claim {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "policy_id", nullable = false)
    private Policy policy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "disruption_id")
    private Disruption disruption;

    @Column(name = "disruption_type", nullable = false, length = 30)
    private String disruptionType;

    @Column(name = "lost_hours", nullable = false)
    private BigDecimal lostHours;

    @Column(name = "hourly_rate", nullable = false)
    private BigDecimal hourlyRate;

    @Column(name = "payout_amount", nullable = false)
    private BigDecimal payoutAmount;

    @Column(name = "claim_status", nullable = false, length = 20)
    private String claimStatus = "pending";

    @Column(name = "fraud_score")
    private BigDecimal fraudScore;

    @Column(name = "fraud_reason")
    private String fraudReason;

    @Column(name = "auto_triggered")
    private Boolean autoTriggered = true;

    @Column(name = "created_at")
    private OffsetDateTime createdAt;

    @Column(name = "updated_at")
    private OffsetDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = OffsetDateTime.now();
        updatedAt = OffsetDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = OffsetDateTime.now();
    }
}
