import 'package:flutter/material.dart';
import '../../main.dart';

class CallCenterDashboardScreen extends StatefulWidget {
  const CallCenterDashboardScreen({super.key});

  @override
  State<CallCenterDashboardScreen> createState() => _CallCenterDashboardScreenState();
}

class _CallCenterDashboardScreenState extends State<CallCenterDashboardScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _tickets = [
    {
      'id': 'SUP-4421',
      'customer': 'Sarah Chen',
      'issue': 'Order delayed 40 min',
      'order': '#FG-8821',
      'waiting': '3m ago',
      'priority': 'High',
    },
    {
      'id': 'SUP-4420',
      'customer': 'Marcus Lee',
      'issue': 'Wrong items delivered',
      'order': '#FG-8810',
      'waiting': '8m ago',
      'priority': 'High',
    },
    {
      'id': 'SUP-4418',
      'customer': 'Emma Rossi',
      'issue': 'Payment charged twice',
      'order': '#FG-8799',
      'waiting': '12m ago',
      'priority': 'Medium',
    },
    {
      'id': 'SUP-4415',
      'customer': 'James Torres',
      'issue': 'Cannot find restaurant address',
      'order': 'N/A',
      'waiting': '20m ago',
      'priority': 'Low',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _tickets.where((t) {
      if (_selectedFilter == 'All') return true;
      return t['priority'] == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Block with support stats
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2B3A4A), Color(0xFF1E2730)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
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
                            Text('🎧', style: TextStyle(fontSize: 28)),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FoodGo Helpdesk',
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  'Agent: Alex M. · Online',
                                  style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.support_agent_rounded, color: Colors.white54, size: 28),
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildHelpStat('Waiting Tickets', '${_tickets.length} unresolved'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildHelpStat('SLA Target', '98% Response'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Filter selectors
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter by Severity',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E1E24)),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildFilterChip('All'),
                        const SizedBox(width: 8),
                        _buildFilterChip('High'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Medium'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Low'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Tickets List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support Queue (${filtered.length})',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E1E24)),
                    ),
                    const SizedBox(height: 12),
                    if (filtered.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text('🎉 No tickets found with this priority!'),
                        ),
                      )
                    else
                      ...filtered.map((t) => _buildTicketCard(t)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpStat(String label, String value) {
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
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2B3A4A) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? const Color(0xFF2B3A4A) : Colors.grey.shade200),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1E1E24),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> t) {
    Color priorityColor = Colors.grey;
    if (t['priority'] == 'High') priorityColor = Colors.red;
    if (t['priority'] == 'Medium') priorityColor = Colors.orange;

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
                t['id'],
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF1E1E24)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${t['priority']} Priority',
                  style: TextStyle(color: priorityColor, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(t['issue'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('Customer: ${t['customer']}', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
              const Spacer(),
              Text('Order: ${t['order']}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontFamily: 'monospace')),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Waiting: ${t['waiting']}', style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B3A4A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ticket ${t['id']} assigned to you!')),
                  );
                },
                child: const Text('Assign to me', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
