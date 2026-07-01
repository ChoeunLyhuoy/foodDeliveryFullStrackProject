package com.foodgo.controller;

import com.foodgo.dto.CreateOrderRequest;
import com.foodgo.dto.UpdateOrderStatusRequest;
import com.foodgo.entity.Order;
import com.foodgo.service.OrderService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
@Tag(name = "2. Orders Management", description = "Endpoints for creating food orders, updating lifecycles, and rider assignments")
public class OrderController {

    private final OrderService orderService;

    @PostMapping
    public Order create(@Valid @RequestBody CreateOrderRequest request) {
        return orderService.createOrder(request);
    }

    @GetMapping("/{id}")
    public Order getById(@PathVariable Long id) {
        return orderService.getById(id);
    }

    @GetMapping("/customer/{customerId}")
    public List<Order> getByCustomer(@PathVariable Long customerId) {
        return orderService.getByCustomer(customerId);
    }

    // Backs the rider app's "chat inbox" (one rider, many active customer orders)
    @GetMapping("/rider/{riderId}/active")
    public List<Order> getActiveOrdersForRider(@PathVariable Long riderId) {
        return orderService.getActiveOrdersForRider(riderId);
    }

    @PatchMapping("/{id}/status")
    public Order updateStatus(@PathVariable Long id, @Valid @RequestBody UpdateOrderStatusRequest request) {
        return orderService.updateStatus(id, request.getStatus());
    }

    @PatchMapping("/{id}/assign-rider/{riderId}")
    public Order assignRider(@PathVariable Long id, @PathVariable Long riderId) {
        return orderService.assignRider(id, riderId);
    }
}
