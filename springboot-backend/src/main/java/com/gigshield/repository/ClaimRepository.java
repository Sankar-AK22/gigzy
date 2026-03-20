package com.gigshield.repository;

import com.gigshield.model.Claim;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Repository
public interface ClaimRepository extends JpaRepository<Claim, UUID> {
    List<Claim> findByUserId(UUID userId);
    List<Claim> findByClaimStatus(String status);
    List<Claim> findByDisruptionId(UUID disruptionId);
    List<Claim> findByUserIdAndClaimStatus(UUID userId, String claimStatus);

    @Query("SELECT SUM(c.payoutAmount) FROM Claim c WHERE c.claimStatus = 'paid'")
    BigDecimal getTotalPaidAmount();

    @Query("SELECT COUNT(c) FROM Claim c WHERE c.claimStatus = 'fraud_flagged'")
    long countFraudFlagged();

    long countByClaimStatus(String status);
}
