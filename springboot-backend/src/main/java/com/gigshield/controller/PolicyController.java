package com.gigshield.controller;

import com.gigshield.dto.PolicyCreateRequest;
import com.gigshield.model.Policy;
import com.gigshield.service.PolicyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/policies")
@RequiredArgsConstructor
public class PolicyController {

    private final PolicyService policyService;

    @PostMapping
    public ResponseEntity<Policy> createPolicy(@RequestBody PolicyCreateRequest request) {
        Policy policy = policyService.createWeeklyPolicy(request);
        return ResponseEntity.ok(policy);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Policy> getPolicyById(@PathVariable UUID id) {
        return policyService.getPolicyById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Policy>> getPoliciesByUserId(@PathVariable UUID userId) {
        return ResponseEntity.ok(policyService.getPoliciesByUserId(userId));
    }

    @GetMapping("/active")
    public ResponseEntity<List<Policy>> getActivePolicies() {
        return ResponseEntity.ok(policyService.getActivePolicies());
    }

    @GetMapping("/active/city/{city}")
    public ResponseEntity<List<Policy>> getActivePoliciesByCity(@PathVariable String city) {
        return ResponseEntity.ok(policyService.getActivePoliciesByCity(city));
    }

    @PostMapping("/renew/{userId}")
    public ResponseEntity<Policy> renewPolicy(@PathVariable UUID userId) {
        Policy policy = policyService.renewPolicy(userId);
        return ResponseEntity.ok(policy);
    }

    @GetMapping
    public ResponseEntity<List<Policy>> getAllPolicies() {
        return ResponseEntity.ok(policyService.getAllPolicies());
    }

    @PostMapping("/expire")
    public ResponseEntity<String> expireOldPolicies() {
        policyService.expireOldPolicies();
        return ResponseEntity.ok("Expired policies processed");
    }
}
