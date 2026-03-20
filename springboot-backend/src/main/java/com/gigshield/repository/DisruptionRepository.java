package com.gigshield.repository;

import com.gigshield.model.Disruption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface DisruptionRepository extends JpaRepository<Disruption, UUID> {
    List<Disruption> findByCity(String city);
    List<Disruption> findByIsActiveTrue();
    List<Disruption> findByCityAndIsActiveTrue(String city);
    List<Disruption> findByType(String type);
    long countByIsActiveTrue();
}
