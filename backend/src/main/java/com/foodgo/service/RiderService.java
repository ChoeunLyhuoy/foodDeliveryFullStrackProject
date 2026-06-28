package com.foodgo.service;

import com.foodgo.entity.Rider;
import com.foodgo.repository.RiderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class RiderService {

    private final RiderRepository riderRepository;

    public List<Rider> listAll() {
        return riderRepository.findAll();
    }

    public Rider getById(Long id) {
        return riderRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Rider not found: " + id));
    }

    public Rider setOnlineStatus(Long riderId, boolean online) {
        Rider rider = getById(riderId);
        rider.setIsOnline(online);
        return riderRepository.save(rider);
    }

    public Rider updateLocation(Long riderId, double lat, double lng) {
        Rider rider = getById(riderId);
        rider.setCurrentLat(java.math.BigDecimal.valueOf(lat));
        rider.setCurrentLng(java.math.BigDecimal.valueOf(lng));
        return riderRepository.save(rider);
    }
}
