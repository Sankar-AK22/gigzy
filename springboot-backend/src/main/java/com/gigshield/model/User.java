package com.gigshield.model;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "firebase_uid", unique = true, nullable = false)
    private String firebaseUid;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(unique = true, nullable = false, length = 15)
    private String phone;

    @Column(nullable = false, length = 50)
    private String city;

    @Column(nullable = false, length = 30)
    private String platform;

    @Column(name = "avg_daily_income", nullable = false)
    private BigDecimal avgDailyIncome;

    @Column(name = "working_hours", nullable = false)
    private Integer workingHours;

    @Column(nullable = false, length = 100)
    private String zone;

    private Double latitude;
    private Double longitude;

    @Column(name = "risk_score")
    private BigDecimal riskScore;

    @Column(name = "is_active")
    private Boolean isActive = true;

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
