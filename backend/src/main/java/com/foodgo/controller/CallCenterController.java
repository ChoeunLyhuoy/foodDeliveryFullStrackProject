package com.foodgo.controller;

import com.foodgo.entity.CallCenterTicket;
import com.foodgo.service.CallCenterService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/call-center/tickets")
@RequiredArgsConstructor
@Tag(name = "4. Call Center Dispatch", description = "Endpoints for managing customer support tickets, dispatching agents, and resolution tracking")
public class CallCenterController {

    private final CallCenterService callCenterService;

    @GetMapping("/queue")
    public List<CallCenterTicket> getOpenQueue() {
        return callCenterService.getOpenQueue();
    }

    @GetMapping("/customer/{customerId}")
    public List<CallCenterTicket> getByCustomer(@PathVariable Long customerId) {
        return callCenterService.getByCustomer(customerId);
    }

    @GetMapping("/agent/{agentId}")
    public List<CallCenterTicket> getByAgent(@PathVariable Long agentId) {
        return callCenterService.getByAgent(agentId);
    }

    @GetMapping("/order/{orderId}")
    public List<CallCenterTicket> getByOrder(@PathVariable Long orderId) {
        return callCenterService.getByOrder(orderId);
    }

    @GetMapping("/{id}")
    public CallCenterTicket getById(@PathVariable Long id) {
        return callCenterService.getById(id);
    }

    @PostMapping
    public CallCenterTicket createTicket(@RequestBody CallCenterTicket ticket) {
        return callCenterService.createTicket(ticket);
    }

    @PatchMapping("/{id}/assign/{agentId}")
    public CallCenterTicket assignAgent(@PathVariable Long id, @PathVariable Long agentId) {
        return callCenterService.assignAgent(id, agentId);
    }

    @PatchMapping("/{id}/resolve")
    public CallCenterTicket resolve(@PathVariable Long id) {
        return callCenterService.resolve(id);
    }
}
