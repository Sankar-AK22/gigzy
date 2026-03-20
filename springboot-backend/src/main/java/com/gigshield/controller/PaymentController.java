package com.gigshield.controller;

import com.gigshield.model.Transaction;
import com.gigshield.service.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Transaction>> getTransactionsByUserId(@PathVariable UUID userId) {
        return ResponseEntity.ok(paymentService.getTransactionsByUserId(userId));
    }

    @GetMapping("/claim/{claimId}")
    public ResponseEntity<List<Transaction>> getTransactionsByClaimId(@PathVariable UUID claimId) {
        return ResponseEntity.ok(paymentService.getTransactionsByClaimId(claimId));
    }

    @GetMapping
    public ResponseEntity<List<Transaction>> getAllTransactions() {
        return ResponseEntity.ok(paymentService.getAllTransactions());
    }
}
