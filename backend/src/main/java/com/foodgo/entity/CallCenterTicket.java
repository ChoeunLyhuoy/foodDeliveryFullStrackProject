package com.foodgo.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "call_center_tickets")
@Getter
@Setter
public class CallCenterTicket {

    public enum Status { OPEN, IN_PROGRESS, RESOLVED }
    public enum Priority { LOW, NORMAL, HIGH }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "order_id")
    private Long orderId;

    @Column(name = "customer_id", nullable = false)
    private Long customerId;

    @Column(name = "agent_id")
    private Long agentId;

    @Enumerated(EnumType.STRING)
    private Status status = Status.OPEN;

    @Enumerated(EnumType.STRING)
    private Priority priority = Priority.NORMAL;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;
}
