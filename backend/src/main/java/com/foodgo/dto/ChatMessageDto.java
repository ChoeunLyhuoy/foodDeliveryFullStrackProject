package com.foodgo.dto;

import com.foodgo.entity.ChatMessage;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessageDto {
    private Long id;
    private Long orderId;
    private ChatMessage.Channel channel;
    private Long senderId;
    private ChatMessage.SenderRole senderRole;
    private String message;
    private Boolean isRead;
    private LocalDateTime createdAt;

    public static ChatMessageDto from(ChatMessage m) {
        return new ChatMessageDto(
                m.getId(), m.getOrderId(), m.getChannel(), m.getSenderId(),
                m.getSenderRole(), m.getMessage(), m.getIsRead(), m.getCreatedAt()
        );
    }
}
