package com.foodgo.service;

import com.foodgo.entity.CallCenterTicket;
import com.foodgo.repository.CallCenterTicketRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

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
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found: " + id));
    }

    @Transactional
    public CallCenterTicket createTicket(CallCenterTicket ticket) {
        if (ticket.getStatus() == null) {
            ticket.setStatus(CallCenterTicket.Status.OPEN);
        }
        CallCenterTicket saved = ticketRepository.save(ticket);
        messagingTemplate.convertAndSend("/topic/callcenter/tickets", saved);
        return saved;
    }

    @Transactional
    public CallCenterTicket assignAgent(Long ticketId, Long agentId) {
        CallCenterTicket ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found: " + ticketId));
        ticket.setAgentId(agentId);
        ticket.setStatus(CallCenterTicket.Status.IN_PROGRESS);
        CallCenterTicket saved = ticketRepository.save(ticket);
        messagingTemplate.convertAndSend("/topic/callcenter/tickets", saved);
        messagingTemplate.convertAndSend("/topic/ticket." + ticketId, saved);
        return saved;
    }

    @Transactional
    public CallCenterTicket resolve(Long ticketId) {
        CallCenterTicket ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found: " + ticketId));
        ticket.setStatus(CallCenterTicket.Status.RESOLVED);
        CallCenterTicket saved = ticketRepository.save(ticket);
        messagingTemplate.convertAndSend("/topic/callcenter/tickets", saved);
        messagingTemplate.convertAndSend("/topic/ticket." + ticketId, saved);
        return saved;
    }
}
