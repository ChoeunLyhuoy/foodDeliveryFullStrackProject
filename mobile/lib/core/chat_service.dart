import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'api_service.dart';
import '../models/chat_message.dart';

/// One STOMP client, reused by both chat features (Customer<->Rider and
/// Customer<->Call Center). Each subscription is scoped to a single
/// order + channel, so the two chat surfaces never mix messages, even
/// though they share this same connection.
///
/// channel: 'rider' | 'callcenter'
class ChatService {
  StompClient? _client;
  final Map<String, Function(ChatMessage)> _handlers = {};

  void connect() {
    if (_client != null) return;
    _client = StompClient(
      config: StompConfig(
        url: ApiConfig.wsUrl,
        onConnect: _onConnect,
        onWebSocketError: (error) => print('Chat socket error: $error'),
      ),
    );
    _client!.activate();
  }

  void _onConnect(StompFrame frame) {
    // Re-subscribe anything that was requested before the socket connected.
    _handlers.forEach((topic, handler) => _subscribe(topic, handler));
  }

  void subscribeToChat(int orderId, String channel, Function(ChatMessage) onMessage) {
    final topic = '/topic/order.$orderId.$channel';
    _handlers[topic] = onMessage;
    if (_client?.connected == true) {
      _subscribe(topic, onMessage);
    }
  }

  void _subscribe(String topic, Function(ChatMessage) onMessage) {
    _client?.subscribe(
      destination: topic,
      callback: (frame) {
        if (frame.body != null) {
          onMessage(ChatMessage.fromJson(jsonDecode(frame.body!)));
        }
      },
    );
  }

  void sendMessage(int orderId, String channel, ChatMessage message) {
    _client?.send(
      destination: '/app/chat.$channel.$orderId',
      body: jsonEncode(message.toSendPayload()),
    );
  }

  void dispose() {
    _client?.deactivate();
    _client = null;
  }
}
