package com.gigshield.repository;

import com.gigshield.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {
    Optional<User> findByFirebaseUid(String firebaseUid);
    Optional<User> findByPhone(String phone);
    List<User> findByCity(String city);
    List<User> findByCityAndZone(String city, String zone);
    List<User> findByPlatform(String platform);
    List<User> findByIsActiveTrue();
    long countByIsActiveTrue();
    long countByCity(String city);
}
