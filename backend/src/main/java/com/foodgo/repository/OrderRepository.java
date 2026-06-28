package com.foodgo.repository;

import com.foodgo.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByCustomerId(Long customerId);
    // Used to build the rider's "inbox": every order currently assigned to this rider
    List<Order> findByRiderIdAndStatusNot(Long riderId, Order.Status status);
    List<Order> findByRestaurantId(Long restaurantId);
}
