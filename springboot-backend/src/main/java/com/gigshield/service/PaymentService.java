package com.gigshield.service;

import com.gigshield.model.Claim;
import com.gigshield.model.Transaction;
import com.gigshield.model.User;
import com.gigshield.repository.TransactionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class PaymentService {

    private final TransactionRepository transactionRepository;
    private final ClaimService claimService;

    /**
     * Simulate premium payment via Razorpay sandbox.
     * In production, this would integrate with Razorpay payment gateway.
     */
    @Transactional
    public Transaction processPremiumPayment(User user, BigDecimal amount) {
        log.info("Processing premium payment of ₹{} from user: {}", amount, user.getId());

        // Simulate Razorpay order creation
        String mockOrderId = "order_GS" + System.currentTimeMillis();
        String mockPaymentId = "pay_GS" + System.currentTimeMillis();

        Transaction transaction = Transaction.builder()
                .user(user)
                .type("premium_payment")
                .amount(amount)
                .paymentStatus("completed")
                .razorpayOrderId(mockOrderId)
                .razorpayPaymentId(mockPaymentId)
                .build();

        Transaction saved = transactionRepository.save(transaction);
        log.info("Premium payment completed: {}", saved.getId());
        return saved;
    }

    /**
     * Simulate claim payout via Razorpay sandbox.
     */
    @Transactional
    public Transaction processClaimPayout(Claim claim) {
        log.info("Processing payout of ₹{} for claim: {}", claim.getPayoutAmount(), claim.getId());

        String mockOrderId = "order_GSP" + System.currentTimeMillis();
        String mockPaymentId = "pay_GSP" + System.currentTimeMillis();

        Transaction transaction = Transaction.builder()
                .claim(claim)
                .user(claim.getUser())
                .type("claim_payout")
                .amount(claim.getPayoutAmount())
                .paymentStatus("completed")
                .razorpayOrderId(mockOrderId)
                .razorpayPaymentId(mockPaymentId)
                .build();

        Transaction saved = transactionRepository.save(transaction);

        // Mark claim as paid
        claimService.markPaid(claim.getId());

        log.info("Payout completed: {} for claim: {}", saved.getId(), claim.getId());
        return saved;
    }

    public List<Transaction> getTransactionsByUserId(UUID userId) {
        return transactionRepository.findByUserId(userId);
    }

    public List<Transaction> getTransactionsByClaimId(UUID claimId) {
        return transactionRepository.findByClaimId(claimId);
    }

    public List<Transaction> getAllTransactions() {
        return transactionRepository.findAll();
    }

    public BigDecimal getTotalPremiumCollected() {
        BigDecimal total = transactionRepository.getTotalPremiumCollected();
        return total != null ? total : BigDecimal.ZERO;
    }

    public BigDecimal getTotalPayoutsCompleted() {
        BigDecimal total = transactionRepository.getTotalPayoutsCompleted();
        return total != null ? total : BigDecimal.ZERO;
    }
}
