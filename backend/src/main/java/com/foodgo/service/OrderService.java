package com.foodgo.service;

import com.foodgo.dto.CreateOrderRequest;
import com.foodgo.entity.MenuItem;
import com.foodgo.entity.Order;
import com.foodgo.entity.OrderItem;
import com.foodgo.repository.MenuItemRepository;
import com.foodgo.repository.OrderItemRepository;
import com.foodgo.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

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
                    .orElseThrow(() -> new IllegalArgumentException("Menu item not found: " + itemReq.getMenuItemId()));

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

        // Broadcast real-time order creation event
        messagingTemplate.convertAndSend("/topic/orders/live", result);
        messagingTemplate.convertAndSend("/topic/restaurant/" + result.getRestaurantId() + "/orders", result);

        return result;
    }

    public Order getById(Long id) {
        return orderRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Order not found: " + id));
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

        // Broadcast live status change event via STOMP WebSocket
        messagingTemplate.convertAndSend("/topic/order." + orderId, saved);
        messagingTemplate.convertAndSend("/topic/orders/live", saved);
        if (saved.getRestaurantId() != null) {
            messagingTemplate.convertAndSend("/topic/restaurant/" + saved.getRestaurantId() + "/orders", saved);
        }

        return saved;
    }

    @Transactional
    public Order assignRider(Long orderId, Long riderId) {
        Order order = getById(orderId);
        order.setRiderId(riderId);
        order.setStatus(Order.Status.PICKED_UP);
        Order saved = orderRepository.save(order);

        // Broadcast rider assignment event
        messagingTemplate.convertAndSend("/topic/order." + orderId, saved);
        messagingTemplate.convertAndSend("/topic/orders/live", saved);

        return saved;
    }
}
