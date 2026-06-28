package com.foodgo.controller;

import com.foodgo.dto.ChatMessageDto;
import com.foodgo.dto.SendChatMessageRequest;
import com.foodgo.entity.ChatMessage;
import com.foodgo.service.ChatService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Two independent chat surfaces, same underlying mechanics:
 *
 *  REST (history / initial load):
 *    GET  /api/orders/{orderId}/chat/rider
 *    GET  /api/orders/{orderId}/chat/call-center
 *    POST /api/orders/{orderId}/chat/rider
 *    POST /api/orders/{orderId}/chat/call-center
 *
 *  WebSocket (live, STOMP over /ws):
 *    SEND /app/chat.rider.{orderId}
 *    SEND /app/chat.callcenter.{orderId}
 *    SUBSCRIBE /topic/order.{orderId}.rider
 *    SUBSCRIBE /topic/order.{orderId}.callcenter
 */
@RestController
@RequestMapping("/api/orders/{orderId}/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    @GetMapping("/rider")
    public List<ChatMessageDto> getRiderChatHistory(@PathVariable Long orderId) {
        return chatService.getHistory(orderId, ChatMessage.Channel.RIDER);
    }

    @PostMapping("/rider")
    public ChatMessageDto sendRiderChatMessage(@PathVariable Long orderId,
                                                @Valid @RequestBody SendChatMessageRequest request) {
        return chatService.sendMessage(orderId, ChatMessage.Channel.RIDER, request);
    }

    @GetMapping("/call-center")
    public List<ChatMessageDto> getCallCenterChatHistory(@PathVariable Long orderId) {
        return chatService.getHistory(orderId, ChatMessage.Channel.CALL_CENTER);
    }

    @PostMapping("/call-center")
    public ChatMessageDto sendCallCenterChatMessage(@PathVariable Long orderId,
                                                      @Valid @RequestBody SendChatMessageRequest request) {
        return chatService.sendMessage(orderId, ChatMessage.Channel.CALL_CENTER, request);
    }

    @MessageMapping("/chat.rider.{orderId}")
    public void handleRiderWsMessage(@DestinationVariable Long orderId, @Payload SendChatMessageRequest request) {
        chatService.sendMessage(orderId, ChatMessage.Channel.RIDER, request);
    }

    @MessageMapping("/chat.callcenter.{orderId}")
    public void handleCallCenterWsMessage(@DestinationVariable Long orderId, @Payload SendChatMessageRequest request) {
        chatService.sendMessage(orderId, ChatMessage.Channel.CALL_CENTER, request);
    }
}
