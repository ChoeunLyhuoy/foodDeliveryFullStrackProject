package com.foodgo.controller;

import com.foodgo.entity.MenuItem;
import com.foodgo.entity.Restaurant;
import com.foodgo.entity.Order;
import com.foodgo.service.RestaurantService;
import com.foodgo.service.OrderService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/restaurants")
@RequiredArgsConstructor
@Tag(name = "1. Restaurants & Menu", description = "Endpoints for browsing restaurants, menus, and incoming kitchen orders")
public class RestaurantController {

    private final RestaurantService restaurantService;
    private final OrderService orderService;

    @GetMapping
    public List<Restaurant> listAll() {
        return restaurantService.listAll();
    }

    @GetMapping("/{id}")
    public Restaurant getById(@PathVariable Long id) {
        return restaurantService.getById(id);
    }

    @GetMapping("/{id}/menu")
    public List<MenuItem> getMenu(@PathVariable Long id) {
        return restaurantService.getMenu(id);
    }

    @PostMapping("/{id}/menu")
    public MenuItem addMenuItem(@PathVariable Long id, @RequestBody MenuItem item) {
        item.setRestaurantId(id);
        return restaurantService.addMenuItem(item);
    }

    @PutMapping("/menu/{itemId}")
    public MenuItem updateMenuItem(@PathVariable Long itemId, @RequestBody MenuItem item) {
        return restaurantService.updateMenuItem(itemId, item);
    }

    @GetMapping("/{id}/orders")
    public List<Order> getOrders(@PathVariable Long id) {
        return orderService.getByRestaurant(id);
    }
}
