package com.gigshield.controller;

import com.gigshield.dto.RiskAssessmentResponse;
import com.gigshield.dto.UserRegistrationRequest;
import com.gigshield.model.User;
import com.gigshield.service.AIServiceClient;
import com.gigshield.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final AIServiceClient aiServiceClient;

    @PostMapping("/register")
    public ResponseEntity<User> registerUser(@RequestBody UserRegistrationRequest request) {
        User user = userService.registerUser(request);
        return ResponseEntity.ok(user);
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable UUID id) {
        return userService.getUserById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/firebase/{firebaseUid}")
    public ResponseEntity<User> getUserByFirebaseUid(@PathVariable String firebaseUid) {
        return userService.getUserByFirebaseUid(firebaseUid)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        return ResponseEntity.ok(userService.getAllUsers());
    }

    @GetMapping("/city/{city}")
    public ResponseEntity<List<User>> getUsersByCity(@PathVariable String city) {
        return ResponseEntity.ok(userService.getUsersByCity(city));
    }

    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(@PathVariable UUID id, @RequestBody UserRegistrationRequest request) {
        User updated = userService.updateUser(id, request);
        return ResponseEntity.ok(updated);
    }

    @GetMapping("/{id}/risk-assessment")
    public ResponseEntity<RiskAssessmentResponse> getRiskAssessment(@PathVariable UUID id) {
        User user = userService.getUserById(id)
                .orElseThrow(() -> new RuntimeException("User not found: " + id));

        RiskAssessmentResponse assessment = aiServiceClient.assessRisk(
                user.getCity(),
                user.getZone(),
                user.getAvgDailyIncome().doubleValue(),
                user.getWorkingHours()
        );

        return ResponseEntity.ok(assessment);
    }

    @PostMapping("/{id}/simulate-time")
    public ResponseEntity<User> simulateTimePassed(@PathVariable UUID id, @RequestParam(defaultValue = "31") int days) {
        User updated = userService.simulateTimePassed(id, days);
        return ResponseEntity.ok(updated);
    }
}
