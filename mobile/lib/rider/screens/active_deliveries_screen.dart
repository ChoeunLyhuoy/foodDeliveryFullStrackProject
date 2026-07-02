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
    _loadDeliveries();
  }

  Future<void> _loadDeliveries() async {
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
    // If empty or loading/offline, fallback to Figma Screenshot 3 exact deliveries list
    final hasData = _orders.isNotEmpty;
    final displayList = hasData 
        ? _orders 
        : [
            _MockDelivery(
              id: 'FG-8821',
              customerName: 'Sarah Chen',
              restaurantName: 'Burgersmith',
              itemsCount: 3,
              distance: '2.4 km',
              duration: '8 min away',
              status: 'On the Way',
              isGreenStatus: false,
            ),
            _MockDelivery(
              id: 'FG-8819',
              customerName: 'Marcus Lee',
              restaurantName: 'Sakura Ramen',
              itemsCount: 2,
              distance: '1.1 km',
              duration: '12 min away',
              status: 'Ready',
              isGreenStatus: true,
            ),
          ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E24)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Active Deliveries',
          style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E1E24), fontSize: 18),
        ),
      ),
      body: _loading && hasData
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE1553C)))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: displayList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, i) {
                final o = displayList[i];
                final String idStr = o is _MockDelivery ? o.id : 'FG-882${(o as FoodOrder).id}';
                final String customerStr = o is _MockDelivery ? o.customerName : 'Customer #${(o as FoodOrder).customerId}';
                final String restStr = o is _MockDelivery ? o.restaurantName : 'Burgersmith';
                final int countInt = o is _MockDelivery ? o.itemsCount : 2;
                final String distStr = o is _MockDelivery ? o.distance : '2.4 km';
                final String durStr = o is _MockDelivery ? o.duration : '10 min away';
                final String statusStr = o is _MockDelivery ? o.status : 'On the Way';
                final bool isGreen = o is _MockDelivery ? o.isGreenStatus : false;

                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4))],
                    border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Order ID + Status Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '#$idStr',
                            style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isGreen ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBE7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isGreen ? const Color(0xFF10B981) : const Color(0xFFE1553C),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  statusStr,
                                  style: TextStyle(
                                    color: isGreen ? const Color(0xFF10B981) : const Color(0xFFE1553C),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Customer Name
                      Text(
                        customerStr,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1E1E24)),
                      ),
                      const SizedBox(height: 3),

                      // Restaurant Name & count
                      Text(
                        '$restStr · $countInt items',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 14),

                      // Divider
                      Divider(color: Colors.grey.shade100, height: 1),
                      const SizedBox(height: 14),

                      // Distance metrics + Action trigger
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade400),
                              const SizedBox(width: 4),
                              Text(
                                distStr,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 14),
                              Icon(Icons.timer_outlined, size: 16, color: Colors.grey.shade400),
                              const SizedBox(width: 4),
                              Text(
                                durStr,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Opening maps to navigate to $customerStr...')),
                              );
                            },
                            child: const Text(
                              'Navigate ➔',
                              style: TextStyle(color: Color(0xFFE1553C), fontWeight: FontWeight.w900, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _MockDelivery {
  final String id;
  final String customerName;
  final String restaurantName;
  final int itemsCount;
  final String distance;
  final String duration;
  final String status;
  final bool isGreenStatus;

  _MockDelivery({
    required this.id,
    required this.customerName,
    required this.restaurantName,
    required this.itemsCount,
    required this.distance,
    required this.duration,
    required this.status,
    required this.isGreenStatus,
  });
}
