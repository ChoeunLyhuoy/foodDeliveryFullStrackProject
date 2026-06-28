import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/chat_service.dart';
import '../../models/chat_message.dart';
import '../../widgets/chat_bubble.dart';

class RiderSideChatScreen extends StatefulWidget {
  final int orderId;
  final int riderId;
  const RiderSideChatScreen({super.key, required this.orderId, required this.riderId});

  @override
  State<RiderSideChatScreen> createState() => _RiderSideChatScreenState();
}

class _RiderSideChatScreenState extends State<RiderSideChatScreen> {
  final _api = ApiService();
  final _chat = ChatService();
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

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

  void _send() {
    final text = _controller.text;
    if (text.isEmpty) return;
    _chat.sendMessage(
      widget.orderId,
      'rider',
      ChatMessage(orderId: widget.orderId, channel: 'RIDER', senderId: widget.riderId, senderRole: 'RIDER', message: text),
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
      appBar: AppBar(title: Text('Order #${widget.orderId}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              // currentUserId = this rider's id, so the rider's own messages align right
              itemBuilder: (context, i) => ChatBubble(message: _messages[i], currentUserId: widget.riderId),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Reply to customer...', border: OutlineInputBorder()),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _send),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
