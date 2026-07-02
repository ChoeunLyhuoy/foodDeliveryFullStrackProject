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
          'Live Tracking',
          style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E1E24), fontSize: 18),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBE7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: Color(0xFFE1553C), shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                const Text(
                  'On the Way',
                  style: TextStyle(color: Color(0xFFE1553C), fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock map grid path (Figma Screenshot 4)
            Container(
              height: 240,
              width: double.infinity,
              color: const Color(0xFFE8F5E9).withValues(alpha: 0.4),
              child: Stack(
                children: [
                  // Map Grid Lines Mock
                  CustomPaint(
                    size: const Size(double.infinity, 240),
                    painter: _MapGridPainter(),
                  ),
                  // Path connector (dashed curved line)
                  CustomPaint(
                    size: const Size(double.infinity, 240),
                    painter: _MapPathPainter(),
                  ),

                  // Point 1: Restaurant Burgersmith
                  Positioned(
                    top: 40,
                    right: 40,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF475569),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Text('🏢', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 4),
                          Text('Burgersmith', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),

                  // Point 2: Rider Alex K
                  Positioned(
                    top: 100,
                    left: 120,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1553C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Alex K. · 8 min away',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Color(0xFFE1553C), shape: BoxShape.circle),
                          child: const Icon(Icons.directions_bike_rounded, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ),

                  // Point 3: Customer You
                  Positioned(
                    bottom: 40,
                    left: 40,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Text('📍', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 4),
                          Text('You', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Rider Detail Card (Figma Screenshot 4)
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 15, offset: Offset(0, 5))],
                border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
              ),
              child: Row(
                children: [
                  // Rider Profile Avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2E8F0),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('👨🏻', style: TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alex K.',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1E1E24)),
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 14),
                            SizedBox(width: 2),
                            Text(
                              '4.9 · Honda CBR 150R',
                              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Chat Trigger Icon Button (Figma screenshot)
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RiderChatScreen(orderId: widget.orderId)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFFE1553C), size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Phone Call trigger Icon Button (Figma screenshot)
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Calling rider Alex K...')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Icon(Icons.phone_outlined, color: Color(0xFFE1553C), size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Order Progress Section (Figma Screenshot 4)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E24)),
                  ),
                  const SizedBox(height: 20),

                  // Progress Step 1
                  _buildProgressStep(
                    title: 'Order Confirmed',
                    desc: 'Burgersmith received your order',
                    time: '2:10 PM',
                    isDone: true,
                    isActive: false,
                  ),
                  // Progress Step 2
                  _buildProgressStep(
                    title: 'Preparing',
                    desc: 'Kitchen is preparing your food',
                    time: '2:14 PM',
                    isDone: true,
                    isActive: false,
                  ),
                  // Progress Step 3
                  _buildProgressStep(
                    title: 'Ready for Pickup',
                    desc: 'Alex K. is heading to the restaurant',
                    time: '2:22 PM',
                    isDone: false,
                    isActive: true,
                  ),
                  // Progress Step 4
                  _buildProgressStep(
                    title: 'On the Way',
                    desc: 'Your order is on the way',
                    time: '2:30 PM',
                    isDone: false,
                    isActive: false,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStep({
    required String title,
    required String desc,
    required String time,
    required bool isDone,
    required bool isActive,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator nodes
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isDone 
                      ? const Color(0xFF10B981) 
                      : isActive 
                          ? const Color(0xFFE1553C) 
                          : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : isActive
                          ? Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            )
                          : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.shade200,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Content block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: isDone || isActive ? const Color(0xFF1E1E24) : Colors.grey,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: isActive ? const Color(0xFFE1553C) : Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Mock Map painters
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1.0;

    const step = 20.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE1553C)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(40, 190) // You
      ..quadraticBezierTo(size.width / 2, size.height / 2, size.width - 60, 50); // Burgersmith

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
