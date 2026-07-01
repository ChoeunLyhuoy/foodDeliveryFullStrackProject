package com.foodgo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NotificationPayload {
    private String id;
    private String title;
    private String message;
    private String type; // INFO, SUCCESS, WARNING, ERROR
    private Long referenceId; // orderId or ticketId
    @Builder.Default
    private LocalDateTime timestamp = LocalDateTime.now();
}
