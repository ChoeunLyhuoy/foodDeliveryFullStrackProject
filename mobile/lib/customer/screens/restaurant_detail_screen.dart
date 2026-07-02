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
  String _selectedCategory = 'Burgers';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getMenu(widget.restaurantId);
      if (mounted) {
        setState(() {
          _menu = data;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    // If empty or offline, use Figma Screenshot 2 exact menu items
    final displayedMenu = _menu.isNotEmpty 
        ? _menu 
        : [
            MenuItem(
              id: 101,
              restaurantId: widget.restaurantId,
              name: 'Classic Smash',
              description: 'Double patty, cheddar, lettuce, house sauce',
              price: 12.99,
              isAvailable: true,
              category: 'Burgers',
            ),
            MenuItem(
              id: 102,
              restaurantId: widget.restaurantId,
              name: 'Wagyu Double',
              description: 'Premium wagyu, truffle mayo, aged cheddar',
              price: 22.99,
              isAvailable: true,
              category: 'Burgers',
            ),
            MenuItem(
              id: 103,
              restaurantId: widget.restaurantId,
              name: 'Crispy Chicken',
              description: 'Buttermilk fried chicken, slaw, sriracha',
              price: 14.99,
              isAvailable: true,
              category: 'Burgers',
            ),
          ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image Box with back button and transparent bottom details (Figma Screenshot 2)
            Stack(
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E1E24), Color(0xFF2A2A32)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&auto=format&fit=crop&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Text('🍔', style: TextStyle(fontSize: 80)),
                    ),
                  ),
                ),
                // Dark overlay to read white text easily
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                  ),
                ),
                // Top Action Bar
                Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // White Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E24), size: 20),
                        ),
                      ),
                      // Cart Action Bell
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF1E1E24), size: 20),
                            ),
                            if (cart.lines.isNotEmpty)
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(color: Color(0xFFE1553C), shape: BoxShape.circle),
                                  child: Text(
                                    '${cart.lines.length}',
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Detail Texts bottom-left aligned
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Burgersmith',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'American - Burgers',
                        style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 16),
                          const SizedBox(width: 2),
                          const Text(
                            '4.8',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(width: 8),
                          Text('●', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 8)),
                          const SizedBox(width: 8),
                          const Icon(Icons.timer_outlined, color: Colors.white70, size: 14),
                          const SizedBox(width: 4),
                          const Text(
                            '20-30 min',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          Text('●', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 8)),
                          const SizedBox(width: 8),
                          const Text(
                            '\$2.99 delivery',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Tab bar selector (Figma Screenshot 2)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  _buildCategoryTab('Burgers'),
                  const SizedBox(width: 24),
                  _buildCategoryTab('Sides'),
                  const SizedBox(width: 24),
                  _buildCategoryTab('Drinks'),
                ],
              ),
            ),
            const Divider(color: Color(0xFFF1F3F5), height: 1),

            // Menu List (Figma Screenshot 2 style)
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(color: Color(0xFFE1553C)),
                ),
              )
            else
              ListView.separated(
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedMenu.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, i) {
                  final item = displayedMenu[i];
                  return Row(
                    children: [
                      // Rounded Image Box
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            item.name.toLowerCase().contains('chicken')
                                ? '🍗'
                                : item.name.toLowerCase().contains('wagyu')
                                    ? '🍔'
                                    : '🍔',
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Color(0xFF1E1E24),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.description,
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.name.contains('Smash') 
                                  ? '680 cal' 
                                  : item.name.contains('Wagyu') 
                                      ? '850 cal' 
                                      : '720 cal',
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Color(0xFF1E1E24),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Orange Add button
                      GestureDetector(
                        onTap: () {
                          context.read<CartProvider>().addItem(widget.restaurantId, item);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added ${item.name} to cart!'),
                              duration: const Duration(milliseconds: 800),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: const Color(0xFF1E1E24),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE1553C),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String name) {
    final isSelected = _selectedCategory == name;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = name),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: isSelected ? const Color(0xFFE1553C) : Colors.grey.shade500,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              height: 3,
              width: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFE1553C),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}
