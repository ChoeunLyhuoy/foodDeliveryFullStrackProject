package com.foodgo.service;

import com.foodgo.dto.CreateOrderRequest;
import com.foodgo.entity.MenuItem;
import com.foodgo.entity.Order;
import com.foodgo.entity.OrderItem;
import com.foodgo.repository.MenuItemRepository;
import com.foodgo.repository.OrderItemRepository;
import com.foodgo.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
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
        return orderRepository.save(saved);
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

    // Powers the rider "chat inbox": every non-final order assigned to this rider
    public List<Order> getActiveOrdersForRider(Long riderId) {
        return orderRepository.findByRiderIdAndStatusNot(riderId, Order.Status.DELIVERED);
    }

    @Transactional
    public Order updateStatus(Long orderId, Order.Status status) {
        Order order = getById(orderId);
        order.setStatus(status);
        return orderRepository.save(order);
    }

    @Transactional
    public Order assignRider(Long orderId, Long riderId) {
        Order order = getById(orderId);
        order.setRiderId(riderId);
        order.setStatus(Order.Status.PICKED_UP);
        return orderRepository.save(order);
    }
}
