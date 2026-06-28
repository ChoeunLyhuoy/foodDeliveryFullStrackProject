package com.foodgo.repository;

import com.foodgo.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    List<ChatMessage> findByOrderIdAndChannelOrderByCreatedAtAsc(Long orderId, ChatMessage.Channel channel);
}
