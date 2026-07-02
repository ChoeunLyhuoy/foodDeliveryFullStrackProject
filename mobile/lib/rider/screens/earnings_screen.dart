import 'package:flutter/material.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Earnings',
          style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E1E24), fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Orange Header Box (Figma Screenshot 4)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE1553C), Color(0xFFFF6B4A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE1553C).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THIS WEEK',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '\$484.50',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 20),

                  // Sub stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildWeekStat('68', 'Deliveries'),
                      _buildWeekStat('\$18.60', 'Avg/hr'),
                      _buildWeekStat('4.9★', 'Rating'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Simple Mock Bar Chart representation of weekdays
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar('Mon', 0.6),
                      _buildBar('Tue', 0.8),
                      _buildBar('Wed', 0.5),
                      _buildBar('Thu', 0.7),
                      _buildBar('Fri', 0.9),
                      _buildBar('Sat', 0.4),
                      _buildBar('Sun', 0.3),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Recent Payouts Header
            const Text(
              'Recent Payouts',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1E1E24)),
            ),
            const SizedBox(height: 16),

            // Recent payouts list
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPayoutItem('Today', '12 deliveries', '\$84.50'),
                  const Divider(height: 1, color: Color(0xFFF1F3F5)),
                  _buildPayoutItem('Yesterday', '14 deliveries', '\$92.00'),
                  const Divider(height: 1, color: Color(0xFFF1F3F5)),
                  _buildPayoutItem('Sat Jun 21', '11 deliveries', '\$78.50'),
                  const Divider(height: 1, color: Color(0xFFF1F3F5)),
                  _buildPayoutItem('Fri Jun 20', '13 deliveries', '\$90.00'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildBar(String day, double percent) {
    return Column(
      children: [
        Container(
          height: 50 * percent,
          width: 8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPayoutItem(String title, String subtitle, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF1E1E24)),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            price,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF10B981)),
          ),
        ],
      ),
    );
  }
}
