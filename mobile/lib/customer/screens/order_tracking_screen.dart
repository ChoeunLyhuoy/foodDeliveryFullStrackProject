import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../models/order.dart';
import 'rider_chat_screen.dart';
import 'callcenter_chat_screen.dart';

class OrderTrackingScreen extends StatefulWidget {
  final int orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final _steps = ['PLACED', 'CONFIRMED', 'PREPARING', 'PICKED_UP', 'ON_THE_WAY', 'DELIVERED'];
  FoodOrder? _order;

  @override
  void initState() {
    super.initState();
    ApiService().getOrder(widget.orderId).then((o) => setState(() => _order = o));
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _order == null ? 0 : _steps.indexOf(_order!.status);
    return Scaffold(
      appBar: AppBar(title: Text('Order #${widget.orderId}')),
      body: _order == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 8,
                    children: List.generate(_steps.length, (i) {
                      final done = i <= currentIndex;
                      return Chip(
                        label: Text(_steps[i].replaceAll('_', ' ')),
                        backgroundColor: done ? const Color(0xFFE1553C) : const Color(0xFFE7E0D6),
                        labelStyle: TextStyle(color: done ? Colors.white : Colors.black54),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat with your rider'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RiderChatScreen(orderId: widget.orderId)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.support_agent),
                    label: const Text('Need help? Contact support'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CallCenterChatScreen(orderId: widget.orderId)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
