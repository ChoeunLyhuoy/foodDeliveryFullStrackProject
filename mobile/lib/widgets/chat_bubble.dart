import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final int currentUserId;

  const ChatBubble({super.key, required this.message, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final isMine = message.senderId == currentUserId;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMine ? const Color(0xFFE1553C) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isMine ? null : Border.all(color: const Color(0xFFE7E0D6)),
        ),
        child: Text(
          message.message,
          style: TextStyle(color: isMine ? Colors.white : const Color(0xFF2B2118)),
        ),
      ),
    );
  }
}
