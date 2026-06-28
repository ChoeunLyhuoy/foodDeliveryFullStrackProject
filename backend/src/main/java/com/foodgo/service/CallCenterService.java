package com.foodgo.service;

import com.foodgo.entity.CallCenterTicket;
import com.foodgo.repository.CallCenterTicketRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CallCenterService {

    private final CallCenterTicketRepository ticketRepository;

    // The agent-side support queue: every ticket not yet resolved
    public List<CallCenterTicket> getOpenQueue() {
        return ticketRepository.findByStatusNot(CallCenterTicket.Status.RESOLVED);
    }

    public CallCenterTicket getById(Long id) {
        return ticketRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found: " + id));
    }

    public CallCenterTicket createTicket(CallCenterTicket ticket) {
        ticket.setStatus(CallCenterTicket.Status.OPEN);
        return ticketRepository.save(ticket);
    }

    public CallCenterTicket assignAgent(Long ticketId, Long agentId) {
        CallCenterTicket ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found: " + ticketId));
        ticket.setAgentId(agentId);
        ticket.setStatus(CallCenterTicket.Status.IN_PROGRESS);
        return ticketRepository.save(ticket);
    }

    public CallCenterTicket resolve(Long ticketId) {
        CallCenterTicket ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found: " + ticketId));
        ticket.setStatus(CallCenterTicket.Status.RESOLVED);
        return ticketRepository.save(ticket);
    }
}
