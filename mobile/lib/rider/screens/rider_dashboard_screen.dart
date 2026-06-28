import 'package:flutter/material.dart';
import 'active_deliveries_screen.dart';
import 'chat_inbox_screen.dart';

const int demoRiderId = 1; // Bob Rider, from seed.sql

class RiderDashboardScreen extends StatefulWidget {
  const RiderDashboardScreen({super.key});

  @override
  State<RiderDashboardScreen> createState() => _RiderDashboardScreenState();
}

class _RiderDashboardScreenState extends State<RiderDashboardScreen> {
  bool _online = true;
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      const ActiveDeliveriesScreen(riderId: demoRiderId),
      const ChatInboxScreen(riderId: demoRiderId),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider'),
        actions: [
          Row(
            children: [
              Text(_online ? 'Online' : 'Offline'),
              Switch(value: _online, onChanged: (v) => setState(() => _online = v)),
            ],
          ),
        ],
      ),
      body: pages[_navIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.local_shipping), label: 'Deliveries'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chats'),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today's earnings", style: TextStyle(color: Colors.grey)),
          const Text('\$42.50', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              title: const Text('New order request'),
              subtitle: const Text('Pizza Palace → 45 Riverside Ave'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
