package com.foodgo.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

/**
 * Both chat features (Customer <-> Rider and Customer <-> Call Center) share
 * this single STOMP broker. They are kept logically separate by topic prefix:
 *   /topic/order.{orderId}.rider        -> rider chat for that order
 *   /topic/order.{orderId}.callcenter   -> call center chat for that order
 *
 * A rider's "inbox" view (one rider, many customers) is built client-side by
 * subscribing to the rider-channel topic of every order currently assigned
 * to that rider.
 */
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // Used by the Vue web app (falls back to HTTP streaming if native WS is blocked)
        registry.addEndpoint("/ws")
                .setAllowedOriginPatterns("*")
                .withSockJS();

        // Used by the Flutter mobile apps (plain STOMP-over-WebSocket, no SockJS framing)
        registry.addEndpoint("/ws-native")
                .setAllowedOriginPatterns("*");
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        registry.enableSimpleBroker("/topic");
        registry.setApplicationDestinationPrefixes("/app");
    }
}
