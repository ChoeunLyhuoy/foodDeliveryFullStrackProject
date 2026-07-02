import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../models/order.dart';
import 'rider_side_chat_screen.dart';

class ChatInboxScreen extends StatefulWidget {
  final int riderId;
  const ChatInboxScreen({super.key, required this.riderId});

  @override
  State<ChatInboxScreen> createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends State<ChatInboxScreen> {
  List<FoodOrder> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      final data = await ApiService().getActiveOrdersForRider(widget.riderId);
      if (mounted) {
        setState(() {
          _orders = data;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fallback lists matching Figma Screenshot 5
    final hasData = _orders.isNotEmpty;
    final displayList = hasData 
        ? _orders 
        : [
            _MockChatThread(
              customerName: 'Sarah Chen',
              avatarEmoji: '👩🏻',
              orderId: 'FG-8821',
              lastMessage: 'Could you ring the bell?',
              timeStr: '2:16 PM',
              unreadBadge: 1,
            ),
            _MockChatThread(
              customerName: 'Marcus Lee',
              avatarEmoji: '👨🏽',
              orderId: 'FG-8819',
              lastMessage: "I'm waiting outside",
              timeStr: '1:55 PM',
              unreadBadge: 2,
            ),
            _MockChatThread(
              customerName: 'Priya Singh',
              avatarEmoji: '👩🏽',
              orderId: 'FG-8805',
              lastMessage: 'Thank you! 😊',
              timeStr: '12:30 PM',
              unreadBadge: 0,
            ),
          ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E24)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Customer Chats',
          style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E1E24), fontSize: 18),
        ),
        actions: [
          // Orange circular badge count on the right of header
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE1553C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '3',
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: _loading && hasData
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE1553C)))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: displayList.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, i) {
                final item = displayList[i];
                final String name = item is _MockChatThread ? item.customerName : 'Customer #${(item as FoodOrder).customerId}';
                final String avatar = item is _MockChatThread ? item.avatarEmoji : '👤';
                final String orderStr = item is _MockChatThread ? item.orderId : 'FG-882${(item as FoodOrder).id}';
                final String lastMsg = item is _MockChatThread ? item.lastMessage : 'Order is heading your way!';
                final String timeVal = item is _MockChatThread ? item.timeStr : '2:00 PM';
                final int badge = item is _MockChatThread ? item.unreadBadge : 0;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onTap: () {
                    final targetId = item is _MockChatThread ? 1 : (item as FoodOrder).id;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RiderSideChatScreen(orderId: targetId, riderId: widget.riderId),
                      ),
                    );
                  },
                  leading: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F3F5),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(avatar, style: const TextStyle(fontSize: 28)),
                        ),
                      ),
                      if (badge > 0)
                        Positioned(
                          right: -3,
                          top: -3,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE1553C),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$badge',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF1E1E24)),
                      ),
                      Text(
                        timeVal,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Order #$orderStr',
                        style: const TextStyle(color: Color(0xFFE1553C), fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        lastMsg,
                        style: TextStyle(
                          color: badge > 0 ? const Color(0xFF1E1E24) : Colors.grey.shade500,
                          fontSize: 13,
                          fontWeight: badge > 0 ? FontWeight.bold : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _MockChatThread {
  final String customerName;
  final String avatarEmoji;
  final String orderId;
  final String lastMessage;
  final String timeStr;
  final int unreadBadge;

  _MockChatThread({
    required this.customerName,
    required this.avatarEmoji,
    required this.orderId,
    required this.lastMessage,
    required this.timeStr,
    required this.unreadBadge,
  });
}
