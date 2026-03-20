package com.gigshield.controller;

import com.gigshield.model.Claim;
import com.gigshield.service.ClaimService;
import com.gigshield.service.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/claims")
@RequiredArgsConstructor
public class ClaimController {

    private final ClaimService claimService;
    private final PaymentService paymentService;

    @GetMapping("/{id}")
    public ResponseEntity<Claim> getClaimById(@PathVariable UUID id) {
        return claimService.getClaimById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Claim>> getClaimsByUserId(@PathVariable UUID userId) {
        return ResponseEntity.ok(claimService.getClaimsByUserId(userId));
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<Claim>> getClaimsByStatus(@PathVariable String status) {
        return ResponseEntity.ok(claimService.getClaimsByStatus(status));
    }

    @GetMapping
    public ResponseEntity<List<Claim>> getAllClaims() {
        return ResponseEntity.ok(claimService.getAllClaims());
    }

    @PostMapping("/{id}/approve")
    public ResponseEntity<Claim> approveClaim(@PathVariable UUID id) {
        Claim claim = claimService.approveClaim(id);
        return ResponseEntity.ok(claim);
    }

    @PostMapping("/{id}/reject")
    public ResponseEntity<Claim> rejectClaim(@PathVariable UUID id, @RequestParam String reason) {
        Claim claim = claimService.rejectClaim(id, reason);
        return ResponseEntity.ok(claim);
    }

    @PostMapping("/{id}/payout")
    public ResponseEntity<?> processClaimPayout(@PathVariable UUID id) {
        Claim claim = claimService.getClaimById(id)
                .orElseThrow(() -> new RuntimeException("Claim not found: " + id));

        if (!"approved".equals(claim.getClaimStatus())) {
            return ResponseEntity.badRequest().body("Claim must be approved before payout");
        }

        var transaction = paymentService.processClaimPayout(claim);
        return ResponseEntity.ok(transaction);
    }

    @GetMapping("/fraud")
    public ResponseEntity<List<Claim>> getFraudFlaggedClaims() {
        return ResponseEntity.ok(claimService.getClaimsByStatus("fraud_flagged"));
    }
}
