import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api_service.dart';
import '../../core/cart_provider.dart';
import 'order_tracking_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: cart.lines.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...cart.lines.map((l) => ListTile(
                      title: Text('${l.item.name} × ${l.quantity}'),
                      trailing: Text('\$${(l.item.price * l.quantity).toStringAsFixed(2)}'),
                    )),
                const Divider(),
                ListTile(
                  title: const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('\$${cart.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _checkout(context),
                  child: const Text('Place order'),
                ),
              ],
            ),
    );
  }

  Future<void> _checkout(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final addressController = TextEditingController();
    final address = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delivery address'),
        content: TextField(controller: addressController, decoration: const InputDecoration(hintText: '123 Main St')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, addressController.text), child: const Text('Confirm')),
        ],
      ),
    );
    if (address == null || address.isEmpty) return;

    final order = await ApiService().createOrder(
      customerId: 1, // demo customer (Alice, from seed.sql)
      restaurantId: cart.restaurantId!,
      deliveryAddress: address,
      items: cart.lines.map((l) => {'menuItemId': l.item.id, 'quantity': l.quantity}).toList(),
    );
    cart.clear();
    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderTrackingScreen(orderId: order.id)));
    }
  }
}
