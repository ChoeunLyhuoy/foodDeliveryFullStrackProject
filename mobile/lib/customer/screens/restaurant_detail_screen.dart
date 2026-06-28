import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api_service.dart';
import '../../core/cart_provider.dart';
import '../../models/menu_item.dart';
import 'cart_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final int restaurantId;
  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final _api = ApiService();
  List<MenuItem> _menu = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _api.getMenu(widget.restaurantId).then((data) {
      setState(() {
        _menu = data;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${cart.lines.length}'),
              isLabelVisible: cart.lines.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _menu.length,
              itemBuilder: (context, i) {
                final item = _menu[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.description),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('\$${item.price.toStringAsFixed(2)}'),
                        TextButton(
                          onPressed: () => context.read<CartProvider>().addItem(widget.restaurantId, item),
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
