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
    // The rider's "inbox" is just every active order assigned to them -
    // each row below is a separate customer conversation thread.
    ApiService().getActiveOrdersForRider(widget.riderId).then((data) {
      setState(() {
        _orders = data;
        _loading = false;
      });
    }).catchError((_) {
      setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_orders.isEmpty) return const Center(child: Text('No active customer chats'));

    return ListView.separated(
      itemCount: _orders.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final o = _orders[i];
        return ListTile(
          leading: CircleAvatar(child: Text('#${o.customerId}')),
          title: Text('Customer #${o.customerId} · Order #${o.id}'),
          subtitle: Text(o.status.replaceAll('_', ' ')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RiderSideChatScreen(orderId: o.id, riderId: widget.riderId)),
          ),
        );
      },
    );
  }
}
