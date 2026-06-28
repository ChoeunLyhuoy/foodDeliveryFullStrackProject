import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/chat_service.dart';
import '../../models/chat_message.dart';
import '../../widgets/chat_bubble.dart';

const int demoCustomerId = 1; // Alice, from seed.sql

class RiderChatScreen extends StatefulWidget {
  final int orderId;
  const RiderChatScreen({super.key, required this.orderId});

  @override
  State<RiderChatScreen> createState() => _RiderChatScreenState();
}

class _RiderChatScreenState extends State<RiderChatScreen> {
  final _api = ApiService();
  final _chat = ChatService();
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final _quickReplies = ["I'm at the door", 'On my way down', 'Thank you!'];

  @override
  void initState() {
    super.initState();
    _api.getRiderChatHistory(widget.orderId).then((history) {
      setState(() => _messages.addAll(history));
    });
    _chat.connect();
    _chat.subscribeToChat(widget.orderId, 'rider', (msg) {
      setState(() => _messages.add(msg));
    });
  }

  void _send(String text) {
    if (text.isEmpty) return;
    _chat.sendMessage(
      widget.orderId,
      'rider',
      ChatMessage(orderId: widget.orderId, channel: 'RIDER', senderId: demoCustomerId, senderRole: 'CUSTOMER', message: text),
    );
    _controller.clear();
  }

  @override
  void dispose() {
    _chat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat with your rider')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, i) => ChatBubble(message: _messages[i], currentUserId: demoCustomerId),
            ),
          ),
          Wrap(
            spacing: 6,
            children: _quickReplies
                .map((q) => ActionChip(label: Text(q), onPressed: () => _send(q)))
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Type a message...', border: OutlineInputBorder()),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: () => _send(_controller.text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
