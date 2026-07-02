import 'package:flutter/material.dart';
import 'active_deliveries_screen.dart';
import 'chat_inbox_screen.dart';
import 'earnings_screen.dart';
import 'new_order_request_screen.dart';
import '../../main.dart';

const int demoRiderId = 1;

class RiderDashboardScreen extends StatefulWidget {
  const RiderDashboardScreen({super.key});

  @override
  State<RiderDashboardScreen> createState() => _RiderDashboardScreenState();
}

class _RiderDashboardScreenState extends State<RiderDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _online = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: Drawer(
        backgroundColor: const Color(0xFF0F1117),
        child: Column(
          children: [
            // Drawer Header
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white24,
                ),
                child: const Center(
                  child: Text('👨🏽', style: TextStyle(fontSize: 36)),
                ),
              ),
              accountName: const Text(
                'Alex M.',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              accountEmail: const Text(
                'Rider ID #1 · PP-1A-8888',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white70),
              ),
            ),
            // Menu Items
            ListTile(
              leading: const Icon(Icons.dashboard_outlined, color: Colors.white),
              title: const Text('Rider Console', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.navigation_outlined, color: Colors.white),
              title: const Text('Active Deliveries', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ActiveDeliveriesScreen(riderId: demoRiderId)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.monetization_on_outlined, color: Colors.white),
              title: const Text('Earnings History', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EarningsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.motorcycle_rounded, color: Colors.white),
              title: const Text('Vehicle Profile', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: Colors.white),
              title: const Text('Preferences', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(color: Colors.white12, height: 32),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Color(0xFFE1553C)),
              title: const Text('Sign Out Platform', style: TextStyle(color: Color(0xFFE1553C), fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginRoleScreen()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Vibrant Orange Top Section (Figma Image 2 Exact Layout)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 20, 20, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE1553C), Color(0xFFFF6B4A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row: Title + Online Pill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                            ),
                            const SizedBox(width: 8),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RIDER DASHBOARD',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Hey, Alex 👋',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _online = !_online),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _online ? Colors.white : Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _online ? const Color(0xFFE1553C) : Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _online ? 'Online' : 'Offline',
                                      style: TextStyle(
                                        color: _online ? const Color(0xFFE1553C) : Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              icon: const Icon(Icons.logout_rounded, color: Colors.white),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginRoleScreen()),
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 3 Glass Stats Cards Side-by-Side (Figma Image 2)
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard('\$84.50', 'Today'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildStatCard('12', 'Deliveries'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildStatCard('4.9★', 'Rating'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Main Content Area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // New Order Request Floating Orange Card (Figma Image 2)
                    GestureDetector(
                      onTap: () async {
                        final accepted = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(builder: (_) => const NewOrderRequestScreen()),
                        );
                        if (accepted == true && mounted) {
                          // Jump straight to Active Deliveries screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ActiveDeliveriesScreen(riderId: demoRiderId),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE1553C), Color(0xFFFF8C61)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE1553C).withValues(alpha: 0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'NEW ORDER REQUEST!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Tap to view',
                                    style: TextStyle(
                                      color: Color(0xFFE1553C),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Burgersmith → 123 Main St',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '3 items · 2.4 km   |   \$8.50 payout',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 2x2 Grid of Quick Nav Cards (Figma Image 2)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.35,
                      children: [
                        _buildNavGridCard(
                          '🚚',
                          'Active Deliveries',
                          badgeCount: 2,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ActiveDeliveriesScreen(riderId: demoRiderId)),
                          ),
                        ),
                        _buildNavGridCard(
                          '👛',
                          'Earnings',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EarningsScreen()),
                          ),
                        ),
                        _buildNavGridCard(
                          '💬',
                          'Chat Inbox',
                          badgeCount: 3,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ChatInboxScreen(riderId: demoRiderId)),
                          ),
                        ),
                        _buildNavGridCard(
                          '🧭',
                          'Navigation',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening Navigation routes...')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavGridCard(String emoji, String title, {int? badgeCount, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1E1E24),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            if (badgeCount != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1553C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
