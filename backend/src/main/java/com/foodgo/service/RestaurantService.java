package com.foodgo.service;

import com.foodgo.entity.MenuItem;
import com.foodgo.entity.Restaurant;
import com.foodgo.exception.ResourceNotFoundException;
import com.foodgo.repository.MenuItemRepository;
import com.foodgo.repository.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class RestaurantService {

    private final RestaurantRepository restaurantRepository;
    private final MenuItemRepository menuItemRepository;
    private final SimpMessagingTemplate messagingTemplate;

    public List<Restaurant> listAll() {
        return restaurantRepository.findAll();
    }

    public Restaurant getById(Long id) {
        return restaurantRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Restaurant not found: " + id));
    }

    public List<MenuItem> getMenu(Long restaurantId) {
        return menuItemRepository.findByRestaurantId(restaurantId);
    }

    @Transactional
    public MenuItem addMenuItem(MenuItem item) {
        MenuItem saved = menuItemRepository.save(item);
        try {
            if (saved.getRestaurantId() != null) {
                messagingTemplate.convertAndSend("/topic/restaurant/" + saved.getRestaurantId() + "/menu", saved);
            }
        } catch (Exception e) {
            log.error("Failed to broadcast menu update: {}", e.getMessage());
        }
        return saved;
    }

    @Transactional
    public MenuItem updateMenuItem(Long id, MenuItem updated) {
        MenuItem existing = menuItemRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Menu item not found: " + id));
        existing.setName(updated.getName());
        existing.setDescription(updated.getDescription());
        existing.setPrice(updated.getPrice());
        existing.setImageUrl(updated.getImageUrl());
        existing.setCategory(updated.getCategory());
        existing.setIsAvailable(updated.getIsAvailable());
        MenuItem saved = menuItemRepository.save(existing);
        try {
            if (saved.getRestaurantId() != null) {
                messagingTemplate.convertAndSend("/topic/restaurant/" + saved.getRestaurantId() + "/menu", saved);
            }
        } catch (Exception e) {
            log.error("Failed to broadcast menu update: {}", e.getMessage());
        }
        return saved;
    }
}
