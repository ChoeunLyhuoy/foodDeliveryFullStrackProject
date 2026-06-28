package com.foodgo.controller;

import com.foodgo.entity.Rider;
import com.foodgo.service.RiderService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/riders")
@RequiredArgsConstructor
public class RiderController {

    private final RiderService riderService;

    @GetMapping
    public List<Rider> listAll() {
        return riderService.listAll();
    }

    @GetMapping("/{id}")
    public Rider getById(@PathVariable Long id) {
        return riderService.getById(id);
    }

    @PatchMapping("/{id}/status")
    public Rider setOnlineStatus(@PathVariable Long id, @RequestBody Map<String, Boolean> body) {
        return riderService.setOnlineStatus(id, body.getOrDefault("online", false));
    }

    @PatchMapping("/{id}/location")
    public Rider updateLocation(@PathVariable Long id, @RequestBody Map<String, Double> body) {
        return riderService.updateLocation(id, body.get("lat"), body.get("lng"));
    }
}
