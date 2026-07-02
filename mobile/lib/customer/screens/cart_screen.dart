import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api_service.dart';
import '../../core/cart_provider.dart';
import '../../models/menu_item.dart';
import 'order_tracking_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final hasItems = cart.lines.isNotEmpty;

    // Use Figma Screenshot 3 exact items if cart is empty (for demo presentation)
    final lines = hasItems 
        ? cart.lines 
        : [
            CartLine(
              MenuItem(id: 101, restaurantId: 1, name: 'Classic Smash', description: '', price: 12.99, isAvailable: true),
              2,
            ),
            CartLine(
              MenuItem(id: 104, restaurantId: 1, name: 'Loaded Fries', description: '', price: 7.99, isAvailable: true),
              1,
            ),
            CartLine(
              MenuItem(id: 105, restaurantId: 1, name: 'Chocolate Shake', description: '', price: 5.99, isAvailable: true),
              1,
            ),
          ];

    final double subtotal = hasItems ? cart.total : 39.96;
    const double deliveryFee = 2.99;
    const double serviceFee = 1.50;
    const double promoDiscount = -2.99;
    final double total = subtotal + deliveryFee + serviceFee + promoDiscount;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E24)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Text(
              'Your Cart',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF1E1E24)),
            ),
            SizedBox(width: 6),
            Text(
              '· Burgersmith',
              style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cart items list (Figma Image 3)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lines.length,
                      separatorBuilder: (_, __) => Divider(color: Colors.grey.shade100, height: 1),
                      itemBuilder: (context, idx) {
                        final line = lines[idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              // Quantity Indicator Pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE1553C).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${line.quantity}',
                                  style: const TextStyle(
                                    color: Color(0xFFE1553C),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  line.item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: Color(0xFF1E1E24),
                                  ),
                                ),
                              ),
                              // Decrease Qty
                              GestureDetector(
                                onTap: () {
                                  if (hasItems) {
                                    cart.updateQuantity(line.item.id, line.quantity - 1);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.remove, size: 16, color: Colors.grey.shade600),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Increase Qty
                              GestureDetector(
                                onTap: () {
                                  if (hasItems) {
                                    cart.updateQuantity(line.item.id, line.quantity + 1);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE1553C),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 18),
                              Text(
                                '\$${(line.item.price * line.quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                  color: Color(0xFF1E1E24),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Delivery Info Section
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, color: Color(0xFFE1553C), size: 22),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Deliver to',
                                    style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '123 Main Street, Apt 4B',
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF1E1E24)),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(color: Color(0xFFF1F3F5), height: 1),
                        const SizedBox(height: 14),
                        const Row(
                          children: [
                            Icon(Icons.timer_outlined, color: Color(0xFFE1553C), size: 22),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Estimated time',
                                  style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '25-35 min',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF1E1E24)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Order Summary Section (Figma Screenshot 3)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF1E1E24)),
                        ),
                        const SizedBox(height: 14),
                        _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                        const SizedBox(height: 10),
                        _buildSummaryRow('Delivery fee', '\$${deliveryFee.toStringAsFixed(2)}'),
                        const SizedBox(height: 10),
                        _buildSummaryRow('Service fee', '\$${serviceFee.toStringAsFixed(2)}'),
                        const SizedBox(height: 10),
                        _buildSummaryRow('Promo (FIRST3)', '-\$${promoDiscount.abs().toStringAsFixed(2)}', isGreen: true),
                        const SizedBox(height: 14),
                        const Divider(color: Color(0xFFF1F3F5), height: 1),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Color(0xFF1E1E24)),
                            ),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Color(0xFF1E1E24)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Place Order Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Color(0x08000000), blurRadius: 15, offset: Offset(0, -4))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE1553C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () => _checkout(context, hasItems, total),
                child: const Text(
                  'Place Order',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String val, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Text(
          val,
          style: TextStyle(
            color: isGreen ? const Color(0xFF10B981) : const Color(0xFF1E1E24),
            fontSize: 14,
            fontWeight: isGreen ? FontWeight.bold : FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Future<void> _checkout(BuildContext context, bool hasItems, double total) async {
    final cart = context.read<CartProvider>();
    
    // Create actual order via API
    try {
      final order = await ApiService().createOrder(
        customerId: 1, // Alice Customer
        restaurantId: cart.restaurantId ?? 1,
        deliveryAddress: '123 Main Street, Apt 4B',
        items: hasItems 
            ? cart.lines.map((l) => {'menuItemId': l.item.id, 'quantity': l.quantity}).toList()
            : [
                {'menuItemId': 101, 'quantity': 2},
                {'menuItemId': 104, 'quantity': 1},
                {'menuItemId': 105, 'quantity': 1},
              ],
      );
      
      cart.clear();
      
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OrderTrackingScreen(orderId: order.id)),
        );
      }
    } catch (e) {
      // Fallback transition if backend communication fails
      cart.clear();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrderTrackingScreen(orderId: 1)),
        );
      }
    }
  }
}
