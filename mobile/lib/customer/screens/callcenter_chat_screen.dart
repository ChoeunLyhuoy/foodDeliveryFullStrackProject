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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _api.getCallCenterChatHistory(widget.orderId).then((history) {
      if (mounted) {
        setState(() {
          _messages.addAll(history);
          _loading = false;
        });
      }
    }).catchError((_) {
      if (mounted) setState(() => _loading = false);
    });
    _chat.connect();
    _chat.subscribeToChat(widget.orderId, 'callcenter', (msg) {
      if (mounted) setState(() => _messages.add(msg));
    });
  }

  void _send() {
    final text = _controller.text.trim();
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Support Dispatch', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.circle, color: Color(0xFF10B981), size: 8),
                SizedBox(width: 4),
                Text('Agent Standby 24/7', style: TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // Banner for quick hotline calling
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFFFF7ED),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFFFFEDD5), shape: BoxShape.circle),
                  child: const Icon(Icons.phone_in_talk, color: Color(0xFFEA580C), size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Urgent Order Emergency?', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF9A3412), fontSize: 13)),
                      Text('Speak directly with a support specialist.', style: TextStyle(color: Color(0xFFC2410C), fontSize: 11)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => launchUrl(Uri.parse('tel:+85512345678')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA580C),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text('Call Now', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFE1553C)))
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('🎧', style: TextStyle(fontSize: 56)),
                            SizedBox(height: 12),
                            Text('How can we help today?', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF1E293B))),
                            SizedBox(height: 6),
                            Text('Send a message below and an agent will reply instantly.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, i) => ChatBubble(message: _messages[i], currentUserId: _demoCustomerId),
                      ),
          ),

          // Chat input bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, -4))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your message to support...',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: const Color(0xFFE1553C),
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: _send,
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
