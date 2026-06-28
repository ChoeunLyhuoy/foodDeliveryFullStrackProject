import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;
import '../../core/api_service.dart';
import '../../core/chat_service.dart';
import '../../models/chat_message.dart';
import '../../widgets/chat_bubble.dart';

const int _demoCustomerId = 1; // Alice, from seed.sql

class CallCenterChatScreen extends StatefulWidget {
  final int orderId;
  const CallCenterChatScreen({super.key, required this.orderId});

  @override
  State<CallCenterChatScreen> createState() => _CallCenterChatScreenState();
}

class _CallCenterChatScreenState extends State<CallCenterChatScreen> {
  final _api = ApiService();
  final _chat = ChatService();
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _api.getCallCenterChatHistory(widget.orderId).then((history) {
      setState(() => _messages.addAll(history));
    });
    _chat.connect();
    // Subscribed to the call-center topic only - this never receives rider-chat messages.
    _chat.subscribeToChat(widget.orderId, 'callcenter', (msg) {
      setState(() => _messages.add(msg));
    });
  }

  void _send() {
    final text = _controller.text;
    if (text.isEmpty) return;
    _chat.sendMessage(
      widget.orderId,
      'callcenter',
      ChatMessage(orderId: widget.orderId, channel: 'CALL_CENTER', senderId: _demoCustomerId, senderRole: 'CUSTOMER', message: text),
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
      appBar: AppBar(title: const Text('Support chat'), backgroundColor: const Color(0xFFF4A100)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, i) => ChatBubble(message: _messages[i], currentUserId: _demoCustomerId),
            ),
          ),
          TextButton.icon(
            icon: const Icon(Icons.call),
            label: const Text('Or call support directly'),
            onPressed: () => launchUrl(Uri.parse('tel:+85512345678')),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Describe your issue...', border: OutlineInputBorder()),
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
