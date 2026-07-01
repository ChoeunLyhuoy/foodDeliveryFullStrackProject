package com.foodgo.service;

import com.foodgo.dto.NotificationPayload;
import com.foodgo.entity.CallCenterTicket;
import com.foodgo.exception.ResourceNotFoundException;
import com.foodgo.repository.CallCenterTicketRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class CallCenterService {

    private final CallCenterTicketRepository ticketRepository;
    private final SimpMessagingTemplate messagingTemplate;

    public List<CallCenterTicket> getOpenQueue() {
        return ticketRepository.findByStatusNot(CallCenterTicket.Status.RESOLVED);
    }

    public List<CallCenterTicket> getByCustomer(Long customerId) {
        return ticketRepository.findByCustomerId(customerId);
    }

    public List<CallCenterTicket> getByAgent(Long agentId) {
        return ticketRepository.findByAgentId(agentId);
    }

    public List<CallCenterTicket> getByOrder(Long orderId) {
        return ticketRepository.findByOrderId(orderId);
    }

    public CallCenterTicket getById(Long id) {
        return ticketRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket not found: " + id));
    }

    @Transactional
    public CallCenterTicket createTicket(CallCenterTicket ticket) {
        if (ticket.getStatus() == null) {
            ticket.setStatus(CallCenterTicket.Status.OPEN);
        }
        CallCenterTicket saved = ticketRepository.save(ticket);

        try {
            messagingTemplate.convertAndSend("/topic/callcenter/tickets", saved);

            NotificationPayload notification = NotificationPayload.builder()
                    .id(UUID.randomUUID().toString())
                    .title("Emergency Support Ticket")
                    .message("Ticket #" + saved.getId() + " for Order #" + saved.getOrderId() + " (" + saved.getPriority() + " priority)")
                    .type("WARNING")
                    .referenceId(saved.getId())
                    .timestamp(LocalDateTime.now())
                    .build();
            messagingTemplate.convertAndSend("/topic/notifications", notification);
        } catch (Exception e) {
            log.error("Failed to broadcast ticket creation notification: {}", e.getMessage());
        }

        return saved;
    }

    @Transactional
    public CallCenterTicket assignAgent(Long ticketId, Long agentId) {
        CallCenterTicket ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket not found: " + ticketId));
        ticket.setAgentId(agentId);
        ticket.setStatus(CallCenterTicket.Status.IN_PROGRESS);
        CallCenterTicket saved = ticketRepository.save(ticket);

        try {
            messagingTemplate.convertAndSend("/topic/callcenter/tickets", saved);
            messagingTemplate.convertAndSend("/topic/ticket." + ticketId, saved);

            NotificationPayload notification = NotificationPayload.builder()
                    .id(UUID.randomUUID().toString())
                    .title("Agent Assigned")
                    .message("Agent #" + agentId + " took Ticket #" + ticketId)
                    .type("INFO")
                    .referenceId(ticketId)
                    .timestamp(LocalDateTime.now())
                    .build();
            messagingTemplate.convertAndSend("/topic/notifications", notification);
        } catch (Exception e) {
            log.error("Failed to broadcast agent assignment notification: {}", e.getMessage());
        }

        return saved;
    }

    @Transactional
    public CallCenterTicket resolve(Long ticketId) {
        CallCenterTicket ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket not found: " + ticketId));
        ticket.setStatus(CallCenterTicket.Status.RESOLVED);
        CallCenterTicket saved = ticketRepository.save(ticket);

        try {
            messagingTemplate.convertAndSend("/topic/callcenter/tickets", saved);
            messagingTemplate.convertAndSend("/topic/ticket." + ticketId, saved);

            NotificationPayload notification = NotificationPayload.builder()
                    .id(UUID.randomUUID().toString())
                    .title("Ticket Resolved")
                    .message("Support Ticket #" + ticketId + " has been marked resolved.")
                    .type("SUCCESS")
                    .referenceId(ticketId)
                    .timestamp(LocalDateTime.now())
                    .build();
            messagingTemplate.convertAndSend("/topic/notifications", notification);
        } catch (Exception e) {
            log.error("Failed to broadcast resolution notification: {}", e.getMessage());
        }

        return saved;
    }
}
