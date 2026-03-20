package com.gigshield.model;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "disruptions")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Disruption {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 30)
    private String type;

    @Column(nullable = false, length = 100)
    private String location;

    @Column(nullable = false, length = 50)
    private String city;

    @Column(nullable = false, length = 10)
    private String severity;

    private String description;

    @Column(name = "parameter_value")
    private BigDecimal parameterValue;

    @Column(name = "parameter_unit", length = 20)
    private String parameterUnit;

    private Double latitude;
    private Double longitude;

    @Column(name = "radius_km")
    private BigDecimal radiusKm;

    @Column(name = "started_at", nullable = false)
    private OffsetDateTime startedAt;

    @Column(name = "ended_at")
    private OffsetDateTime endedAt;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "created_at")
    private OffsetDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = OffsetDateTime.now();
    }
}
