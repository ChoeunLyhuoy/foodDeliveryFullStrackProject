import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../models/order.dart';

class ActiveDeliveriesScreen extends StatefulWidget {
  final int riderId;
  const ActiveDeliveriesScreen({super.key, required this.riderId});

  @override
  State<ActiveDeliveriesScreen> createState() => _ActiveDeliveriesScreenState();
}

class _ActiveDeliveriesScreenState extends State<ActiveDeliveriesScreen> {
  List<FoodOrder> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
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
    if (_orders.isEmpty) return const Center(child: Text('No active deliveries'));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _orders.length,
      itemBuilder: (context, i) {
        final o = _orders[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text('Order #${o.id} — ${o.status.replaceAll('_', ' ')}'),
            subtitle: Text(o.deliveryAddress),
            trailing: const Icon(Icons.navigation_outlined),
          ),
        );
      },
    );
  }
}
