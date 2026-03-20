package com.gigshield.repository;

import com.gigshield.model.Policy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Repository
public interface PolicyRepository extends JpaRepository<Policy, UUID> {
    List<Policy> findByUserId(UUID userId);
    List<Policy> findByStatus(String status);
    List<Policy> findByUserIdAndStatus(UUID userId, String status);

    @Query("SELECT p FROM Policy p WHERE p.status = 'active' AND p.startDate <= :date AND p.endDate >= :date")
    List<Policy> findActivePoliciesOnDate(LocalDate date);

    @Query("SELECT p FROM Policy p WHERE p.user.city = :city AND p.status = 'active' AND p.startDate <= :date AND p.endDate >= :date")
    List<Policy> findActivePoliciesByCityOnDate(String city, LocalDate date);

    @Query("SELECT SUM(p.premium) FROM Policy p WHERE p.status = 'active'")
    BigDecimal getTotalActivePremiums();

    long countByStatus(String status);
}
