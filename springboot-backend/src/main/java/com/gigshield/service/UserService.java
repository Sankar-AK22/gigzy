package com.gigshield.service;

import com.gigshield.dto.UserRegistrationRequest;
import com.gigshield.model.User;
import com.gigshield.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserService {

    private final UserRepository userRepository;

    @Transactional
    public User registerUser(UserRegistrationRequest request) {
        log.info("Registering new user: {}", request.getPhone());

        // Check if user already exists
        Optional<User> existing = userRepository.findByFirebaseUid(request.getFirebaseUid());
        if (existing.isPresent()) {
            log.info("User already exists with firebase UID: {}", request.getFirebaseUid());
            return existing.get();
        }

        User user = User.builder()
                .firebaseUid(request.getFirebaseUid())
                .name(request.getName())
                .phone(request.getPhone())
                .city(request.getCity())
                .platform(request.getPlatform())
                .avgDailyIncome(request.getAvgDailyIncome())
                .workingHours(request.getWorkingHours())
                .zone(request.getZone())
                .latitude(request.getLatitude())
                .longitude(request.getLongitude())
                .riskScore(BigDecimal.ZERO)
                .isActive(true)
                .build();

        return userRepository.save(user);
    }

    public Optional<User> getUserById(UUID id) {
        return userRepository.findById(id);
    }

    public Optional<User> getUserByFirebaseUid(String firebaseUid) {
        return userRepository.findByFirebaseUid(firebaseUid);
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public List<User> getUsersByCity(String city) {
        return userRepository.findByCity(city);
    }

    public List<User> getUsersByCityAndZone(String city, String zone) {
        return userRepository.findByCityAndZone(city, zone);
    }

    public List<User> getActiveUsers() {
        return userRepository.findByIsActiveTrue();
    }

    @Transactional
    public User updateRiskScore(UUID userId, BigDecimal riskScore) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found: " + userId));
        user.setRiskScore(riskScore);
        return userRepository.save(user);
    }

    @Transactional
    public User updateUser(UUID userId, UserRegistrationRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found: " + userId));

        if (request.getName() != null) user.setName(request.getName());
        if (request.getCity() != null) user.setCity(request.getCity());
        if (request.getPlatform() != null) user.setPlatform(request.getPlatform());
        if (request.getAvgDailyIncome() != null) user.setAvgDailyIncome(request.getAvgDailyIncome());
        if (request.getWorkingHours() != null) user.setWorkingHours(request.getWorkingHours());
        if (request.getZone() != null) user.setZone(request.getZone());
        if (request.getLatitude() != null) user.setLatitude(request.getLatitude());
        if (request.getLongitude() != null) user.setLongitude(request.getLongitude());

        return userRepository.save(user);
    }

    public long getTotalActiveWorkers() {
        return userRepository.countByIsActiveTrue();
    }

    @Transactional
    public User simulateTimePassed(UUID userId, int days) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found: " + userId));
        
        user.setCreatedAt(java.time.OffsetDateTime.now().minusDays(days));
        return userRepository.save(user);
    }
}
