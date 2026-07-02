import 'dart:async';
import 'package:flutter/material.dart';

class NewOrderRequestScreen extends StatefulWidget {
  const NewOrderRequestScreen({super.key});

  @override
  State<NewOrderRequestScreen> createState() => _NewOrderRequestScreenState();
}

class _NewOrderRequestScreenState extends State<NewOrderRequestScreen> {
  int _secondsRemaining = 24;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        // Time expired fallback
        if (mounted) {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Circular timer progress value
    final progress = _secondsRemaining / 24.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E24)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'New Order!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF1E1E24)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Accept within ${_secondsRemaining}s or it will be reassigned',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 40),

                  // Circular Countdown Timer (Figma Screenshot 2)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey.shade100,
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE1553C)),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$_secondsRemaining',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1E24),
                            ),
                          ),
                          Text(
                            'seconds',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Detail locations card (Figma Screenshot 2)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 15, offset: Offset(0, 5))],
                      border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row 1: Restaurant info
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFEBE7),
                                shape: BoxShape.circle,
                              ),
                              child: const Text('🍔', style: TextStyle(fontSize: 16)),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Burgersmith',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1E1E24)),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    '456 Food Street · 0.8 km away',
                                    style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        // Connector line
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                            height: 20,
                            width: 2,
                            color: Colors.grey.shade200,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Row 2: Customer info
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE0F2FE),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.location_on_rounded, color: Colors.blue, size: 16),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sarah Chen',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1E1E24)),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    '123 Main Street, Apt 4B · 2.4 km',
                                    style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Stats row (Figma Screenshot 2)
                        Row(
                          children: [
                            Expanded(child: _buildOrderStat('3', 'Items')),
                            const SizedBox(width: 10),
                            Expanded(child: _buildOrderStat('2.4 km', 'Distance')),
                            const SizedBox(width: 10),
                            Expanded(child: _buildOrderStat('\$8.50', 'Payout')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Accept Order Button
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
                onPressed: () {
                  _timer?.cancel();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order accepted successfully!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context, true); // Returns true to notify accept success
                },
                child: const Text(
                  'Accept Order',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStat(String val, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1E1E24)),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
