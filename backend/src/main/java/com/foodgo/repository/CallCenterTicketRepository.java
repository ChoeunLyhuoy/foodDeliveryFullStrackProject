package com.foodgo.repository;

import com.foodgo.entity.CallCenterTicket;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CallCenterTicketRepository extends JpaRepository<CallCenterTicket, Long> {
    List<CallCenterTicket> findByStatusNot(CallCenterTicket.Status status);
    List<CallCenterTicket> findByCustomerId(Long customerId);
}
