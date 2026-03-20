package com.gigshield.controller;

import com.gigshield.dto.DashboardStats;
import com.gigshield.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {

    private final DashboardService dashboardService;

    @GetMapping("/dashboard/stats")
    public ResponseEntity<DashboardStats> getDashboardStats() {
        return ResponseEntity.ok(dashboardService.getDashboardStats());
    }
}
