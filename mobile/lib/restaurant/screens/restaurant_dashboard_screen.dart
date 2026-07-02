import 'package:flutter/material.dart';

class RestaurantDashboardScreen extends StatefulWidget {
  const RestaurantDashboardScreen({super.key});

  @override
  State<RestaurantDashboardScreen> createState() => _RestaurantDashboardScreenState();
}

class _RestaurantDashboardScreenState extends State<RestaurantDashboardScreen> {
  bool _isOpen = true;
  String _selectedTab = 'Active';

  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'FG-8821',
      'customer': 'Sarah Chen',
      'items': '2x Truffle Burrata Pizza, 1x Coke',
      'status': 'New',
      'time': '3m ago',
      'amount': '\$29.50',
    },
    {
      'id': 'FG-8810',
      'customer': 'Marcus Lee',
      'items': '1x Wagyu Truffle Smash Burger, 1x Fries',
      'status': 'Preparing',
      'time': '8m ago',
      'amount': '\$16.00',
    },
    {
      'id': 'FG-8799',
      'customer': 'Emma Rossi',
      'items': '1x Signature Tonkotsu Ramen, 1x Matcha Mochi',
      'status': 'Ready',
      'time': '12m ago',
      'amount': '\$15.00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dark Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E24),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text('🍔', style: TextStyle(fontSize: 28)),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Burgersmith',
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  'Kitchen Terminal #1',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Switch(
                          value: _isOpen,
                          activeColor: const Color(0xFFE1553C),
                          onChanged: (val) {
                            setState(() => _isOpen = val);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_isOpen ? 'Store is now OPEN ●' : 'Store is now CLOSED ○'),
                                backgroundColor: _isOpen ? Colors.green : Colors.red,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Stats grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildHeaderStat('Today\'s Revenue', '\$1,240.50', '↑ 12%'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildHeaderStat('Active Orders', '3 Live', 'Prep avg: 14m'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Tab options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildTabButton('Active'),
                    const SizedBox(width: 10),
                    _buildTabButton('Past Orders'),
                    const SizedBox(width: 10),
                    _buildTabButton('Menu Control'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Conditional rendering based on tab
              if (_selectedTab == 'Active')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Live Order Stream',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E1E24)),
                      ),
                      const SizedBox(height: 12),
                      ..._orders.map((o) => _buildOrderCard(o)),
                    ],
                  ),
                )
              else if (_selectedTab == 'Past Orders')
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Text('📦', style: TextStyle(fontSize: 50)),
                        SizedBox(height: 10),
                        Text(
                          'No recent past orders in this shift',
                          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                _buildMenuControlTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, String desc) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(color: Color(0xFFE1553C), fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildTabButton(String name) {
    final isSelected = _selectedTab == name;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = name),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE1553C) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFFE1553C) : Colors.grey.shade200),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1E1E24),
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> o) {
    Color statusColor = Colors.blue;
    if (o['status'] == 'Preparing') statusColor = Colors.orange;
    if (o['status'] == 'Ready') statusColor = Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${o['id']}',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1E1E24)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  o['status'],
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Customer: ${o['customer']}', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(o['items'], style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(o['time'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Row(
                children: [
                  Text(o['amount'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE1553C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Order ${o['id']} status updated!')),
                      );
                    },
                    child: const Text('Advance ➔', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMenuControlTab() {
    final List<Map<String, dynamic>> menuItems = [
      {'name': 'Truffle Burrata Margherita Pizza', 'price': '\$12.50', 'avail': true},
      {'name': 'Wagyu Truffle Smash Burger', 'price': '\$10.50', 'avail': true},
      {'name': 'Signature Tonkotsu Ramen', 'price': '\$11.00', 'avail': false},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Availability Toggle',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E1E24)),
          ),
          const SizedBox(height: 12),
          ...menuItems.map((item) => Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: Text(item['price'], style: const TextStyle(color: Color(0xFFE1553C), fontWeight: FontWeight.bold)),
                  trailing: Switch(
                    value: item['avail'],
                    activeColor: const Color(0xFFE1553C),
                    onChanged: (val) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item['name']} availability updated!')),
                      );
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
