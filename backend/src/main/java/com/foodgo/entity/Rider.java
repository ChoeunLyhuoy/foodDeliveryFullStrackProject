package com.foodgo.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;

@Entity
@Table(name = "riders")
@Getter
@Setter
public class Rider {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false, unique = true)
    private Long userId;

    @Column(name = "vehicle_type")
    private String vehicleType;

    @Column(name = "is_online")
    private Boolean isOnline = false;

    @Column(name = "current_lat")
    private BigDecimal currentLat;

    @Column(name = "current_lng")
    private BigDecimal currentLng;

    private BigDecimal rating;
}
