package com.foodgo.service;

import com.foodgo.dto.CreateOrderRequest;
import com.foodgo.dto.NotificationPayload;
import com.foodgo.entity.MenuItem;
import com.foodgo.entity.Order;
import com.foodgo.entity.OrderItem;
import com.foodgo.exception.ResourceNotFoundException;
import com.foodgo.repository.MenuItemRepository;
import com.foodgo.repository.OrderItemRepository;
import com.foodgo.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final MenuItemRepository menuItemRepository;
    private final SimpMessagingTemplate messagingTemplate;

    @Transactional
    public Order createOrder(CreateOrderRequest request) {
        Order order = new Order();
        order.setCustomerId(request.getCustomerId());
        order.setRestaurantId(request.getRestaurantId());
        order.setDeliveryAddress(request.getDeliveryAddress());
        order.setStatus(Order.Status.PLACED);

        BigDecimal total = BigDecimal.ZERO;
        Order saved = orderRepository.save(order);

        for (CreateOrderRequest.Item itemReq : request.getItems()) {
            MenuItem menuItem = menuItemRepository.findById(itemReq.getMenuItemId())
                    .orElseThrow(() -> new ResourceNotFoundException("Menu item not found: " + itemReq.getMenuItemId()));

            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(saved.getId());
            orderItem.setMenuItemId(menuItem.getId());
            orderItem.setQuantity(itemReq.getQuantity());
            orderItem.setUnitPrice(menuItem.getPrice());
            orderItem.setNotes(itemReq.getNotes());
            orderItemRepository.save(orderItem);

            total = total.add(menuItem.getPrice().multiply(BigDecimal.valueOf(itemReq.getQuantity())));
        }

        saved.setTotalAmount(total);
        Order result = orderRepository.save(saved);

        // Safe broadcast with try-catch
        try {
            messagingTemplate.convertAndSend("/topic/orders/live", result);
            messagingTemplate.convertAndSend("/topic/restaurant/" + result.getRestaurantId() + "/orders", result);

            NotificationPayload notification = NotificationPayload.builder()
                    .id(UUID.randomUUID().toString())
                    .title("New Order Placed")
                    .message("Order #" + result.getId() + " placed for $" + result.getTotalAmount())
                    .type("SUCCESS")
                    .referenceId(result.getId())
                    .timestamp(LocalDateTime.now())
                    .build();
            messagingTemplate.convertAndSend("/topic/notifications", notification);
        } catch (Exception e) {
            log.error("Failed to broadcast order creation notifications: {}", e.getMessage());
        }

        return result;
    }

    public Order getById(Long id) {
        return orderRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found: " + id));
    }

    public List<Order> getByCustomer(Long customerId) {
        return orderRepository.findByCustomerId(customerId);
    }

    public List<Order> getByRestaurant(Long restaurantId) {
        return orderRepository.findByRestaurantId(restaurantId);
    }

    public List<Order> getActiveOrdersForRider(Long riderId) {
        return orderRepository.findByRiderIdAndStatusNot(riderId, Order.Status.DELIVERED);
    }

    @Transactional
    public Order updateStatus(Long orderId, Order.Status status) {
        Order order = getById(orderId);
        order.setStatus(status);
        Order saved = orderRepository.save(order);

        try {
            messagingTemplate.convertAndSend("/topic/order." + orderId, saved);
            messagingTemplate.convertAndSend("/topic/orders/live", saved);
            if (saved.getRestaurantId() != null) {
                messagingTemplate.convertAndSend("/topic/restaurant/" + saved.getRestaurantId() + "/orders", saved);
            }

            NotificationPayload notification = NotificationPayload.builder()
                    .id(UUID.randomUUID().toString())
                    .title("Order Status Updated")
                    .message("Order #" + orderId + " is now " + status.name())
                    .type("INFO")
                    .referenceId(orderId)
                    .timestamp(LocalDateTime.now())
                    .build();
            messagingTemplate.convertAndSend("/topic/notifications", notification);
        } catch (Exception e) {
            log.error("Failed to broadcast order status notification: {}", e.getMessage());
        }

        return saved;
    }

    @Transactional
    public Order assignRider(Long orderId, Long riderId) {
        Order order = getById(orderId);
        order.setRiderId(riderId);
        order.setStatus(Order.Status.PICKED_UP);
        Order saved = orderRepository.save(order);

        try {
            messagingTemplate.convertAndSend("/topic/order." + orderId, saved);
            messagingTemplate.convertAndSend("/topic/orders/live", saved);

            NotificationPayload notification = NotificationPayload.builder()
                    .id(UUID.randomUUID().toString())
                    .title("Rider Assigned")
                    .message("Rider #" + riderId + " assigned to Order #" + orderId)
                    .type("INFO")
                    .referenceId(orderId)
                    .timestamp(LocalDateTime.now())
                    .build();
            messagingTemplate.convertAndSend("/topic/notifications", notification);
        } catch (Exception e) {
            log.error("Failed to broadcast rider assignment notification: {}", e.getMessage());
        }

        return saved;
    }
}
