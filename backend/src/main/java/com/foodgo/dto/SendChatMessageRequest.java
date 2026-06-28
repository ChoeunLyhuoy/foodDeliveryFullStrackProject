package com.foodgo.dto;

import com.foodgo.entity.ChatMessage;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SendChatMessageRequest {
    @NotNull
    private Long senderId;

    @NotNull
    private ChatMessage.SenderRole senderRole;

    @NotBlank
    private String message;
}
