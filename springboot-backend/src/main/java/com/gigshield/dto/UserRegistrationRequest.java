package com.gigshield.dto;

import lombok.*;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserRegistrationRequest {
    private String firebaseUid;
    private String name;
    private String phone;
    private String city;
    private String platform;
    private BigDecimal avgDailyIncome;
    private Integer workingHours;
    private String zone;
    private Double latitude;
    private Double longitude;
}
