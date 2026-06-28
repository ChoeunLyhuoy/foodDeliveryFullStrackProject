package com.foodgo.service;

import com.foodgo.dto.ChatMessageDto;
import com.foodgo.dto.SendChatMessageRequest;
import com.foodgo.entity.ChatMessage;
import com.foodgo.repository.ChatMessageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Handles both chat channels. They share the same persistence + websocket
 * mechanics but are kept logically separate by `channel` and by topic name,
 * so a message sent on the rider channel never crosses into the call-center
 * channel and vice-versa.
 */
@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatMessageRepository chatMessageRepository;
    private final SimpMessagingTemplate messagingTemplate;

    public List<ChatMessageDto> getHistory(Long orderId, ChatMessage.Channel channel) {
        return chatMessageRepository.findByOrderIdAndChannelOrderByCreatedAtAsc(orderId, channel)
                .stream().map(ChatMessageDto::from).collect(Collectors.toList());
    }

    public ChatMessageDto sendMessage(Long orderId, ChatMessage.Channel channel, SendChatMessageRequest request) {
        ChatMessage message = new ChatMessage();
        message.setOrderId(orderId);
        message.setChannel(channel);
        message.setSenderId(request.getSenderId());
        message.setSenderRole(request.getSenderRole());
        message.setMessage(request.getMessage());
        message.setIsRead(false);

        ChatMessage saved = chatMessageRepository.save(message);
        ChatMessageDto dto = ChatMessageDto.from(saved);

        // Broadcast to whoever is subscribed to this order+channel's topic
        String topic = "/topic/order." + orderId + "." + channel.name().toLowerCase().replace("_", "");
        messagingTemplate.convertAndSend(topic, dto);

        return dto;
    }
}
