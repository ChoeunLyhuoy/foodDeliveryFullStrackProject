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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Row(
          children: [
            Text('Customer Messages', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
            SizedBox(width: 8),
            ContainerSpanLive(),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E1E24),
        elevation: 0.5,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE1553C)))
          : RefreshIndicator(
              onRefresh: _loadChats,
              color: const Color(0xFFE1553C),
              child: _orders.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 120),
                        Center(
                          child: Column(
                            children: [
                              Text('💬', style: TextStyle(fontSize: 60)),
                              SizedBox(height: 16),
                              Text(
                                'No Active Customer Chats',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E1E24)),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'When you accept active orders, real-time messaging\nchannels with customers appear here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _orders.length,
                      itemBuilder: (context, i) {
                        final o = _orders[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RiderSideChatScreen(orderId: o.id, riderId: widget.riderId),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 54,
                                      height: 54,
                                      decoration: const BoxDecoration(
                                        color: Color(0x1EE1553C),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '#${o.customerId}',
                                          style: const TextStyle(
                                            color: Color(0xFFE1553C),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Customer #${o.customerId}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16,
                                                  color: Color(0xFF1E1E24),
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFE8F5E9),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  'Order #${o.id}',
                                                  style: const TextStyle(
                                                    color: Color(0xFF2E7D32),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.delivery_dining, size: 16, color: Color(0xFFE1553C)),
                                              const SizedBox(width: 6),
                                              Text(
                                                o.status.replaceAll('_', ' '),
                                                style: const TextStyle(
                                                  color: Color(0xFF64748B),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFCBD5E1)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}

class ContainerSpanLive extends StatelessWidget {
  const ContainerSpanLive({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: Color(0xFF2E7D32), size: 8),
          SizedBox(width: 4),
          Text(
            'LIVE',
            style: TextStyle(color: Color(0xFF2E7D32), fontSize: 10, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
