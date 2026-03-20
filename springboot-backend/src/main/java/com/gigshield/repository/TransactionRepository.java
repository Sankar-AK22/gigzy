package com.gigshield.repository;

import com.gigshield.model.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, UUID> {
    List<Transaction> findByUserId(UUID userId);
    List<Transaction> findByClaimId(UUID claimId);
    List<Transaction> findByPaymentStatus(String status);
    List<Transaction> findByType(String type);

    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.type = 'premium_payment' AND t.paymentStatus = 'completed'")
    BigDecimal getTotalPremiumCollected();

    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.type = 'claim_payout' AND t.paymentStatus = 'completed'")
    BigDecimal getTotalPayoutsCompleted();
}
