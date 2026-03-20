package com.gigshield.controller;

import com.gigshield.model.Disruption;
import com.gigshield.service.TriggerService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/disruptions")
@RequiredArgsConstructor
public class DisruptionController {

    private final TriggerService triggerService;

    /**
     * Manually trigger a disruption event.
     * In production, this would be called by the scheduled trigger service.
     */
    @PostMapping("/trigger")
    public ResponseEntity<Disruption> triggerDisruption(@RequestBody Disruption disruption) {
        Disruption processed = triggerService.processDisruption(disruption);
        return ResponseEntity.ok(processed);
    }

    @GetMapping("/active")
    public ResponseEntity<List<Disruption>> getActiveDisruptions() {
        return ResponseEntity.ok(triggerService.getActiveDisruptions());
    }

    @GetMapping("/city/{city}")
    public ResponseEntity<List<Disruption>> getDisruptionsByCity(@PathVariable String city) {
        return ResponseEntity.ok(triggerService.getDisruptionsByCity(city));
    }

    @GetMapping
    public ResponseEntity<List<Disruption>> getAllDisruptions() {
        return ResponseEntity.ok(triggerService.getAllDisruptions());
    }

    @PostMapping("/{id}/end")
    public ResponseEntity<Disruption> endDisruption(@PathVariable UUID id) {
        Disruption ended = triggerService.endDisruption(id);
        return ResponseEntity.ok(ended);
    }
}
