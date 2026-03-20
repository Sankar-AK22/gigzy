package com.gigshield.controller;

import com.gigshield.model.Notification;
import com.gigshield.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Notification>> getUserNotifications(@PathVariable UUID userId) {
        return ResponseEntity.ok(notificationService.getUserNotifications(userId));
    }

    @GetMapping("/user/{userId}/unread")
    public ResponseEntity<List<Notification>> getUnreadNotifications(@PathVariable UUID userId) {
        return ResponseEntity.ok(notificationService.getUnreadNotifications(userId));
    }

    @GetMapping("/user/{userId}/unread/count")
    public ResponseEntity<Map<String, Long>> getUnreadCount(@PathVariable UUID userId) {
        return ResponseEntity.ok(Map.of("count", notificationService.getUnreadCount(userId)));
    }

    @PostMapping("/{id}/read")
    public ResponseEntity<String> markAsRead(@PathVariable UUID id) {
        notificationService.markAsRead(id);
        return ResponseEntity.ok("Marked as read");
    }

    @PostMapping("/user/{userId}/read-all")
    public ResponseEntity<String> markAllAsRead(@PathVariable UUID userId) {
        notificationService.markAllAsRead(userId);
        return ResponseEntity.ok("All marked as read");
    }
}
