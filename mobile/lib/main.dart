import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/cart_provider.dart';
import 'customer/screens/home_screen.dart';
import 'rider/screens/rider_dashboard_screen.dart';
import 'restaurant/screens/restaurant_dashboard_screen.dart';
import 'callcenter/screens/callcenter_dashboard_screen.dart';

void main() {
  runApp(const FoodGoApp());
}

class FoodGoApp extends StatelessWidget {
  const FoodGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'FoodGo Mobile Platform',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFFE1553C),
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        ),
        home: const LoginRoleScreen(),
      ),
    );
  }
}

class LoginRoleScreen extends StatefulWidget {
  const LoginRoleScreen({super.key});

  @override
  State<LoginRoleScreen> createState() => _LoginRoleScreenState();
}

class _LoginRoleScreenState extends State<LoginRoleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // 4 sets of controllers
  final TextEditingController _customerPhone = TextEditingController(text: '+855 12 345 678');
  final TextEditingController _customerPass = TextEditingController(text: 'customer123');

  final TextEditingController _riderPhone = TextEditingController(text: '+855 98 765 432');
  final TextEditingController _riderPass = TextEditingController(text: 'rider123');
  final TextEditingController _riderPlate = TextEditingController(text: 'PP-1A-8888');

  final TextEditingController _partnerPhone = TextEditingController(text: '+855 77 666 555');
  final TextEditingController _partnerPass = TextEditingController(text: 'partner123');
  final TextEditingController _partnerTerminal = TextEditingController(text: 'KITCHEN-BSM-01');

  final TextEditingController _agentPhone = TextEditingController(text: '+855 88 999 000');
  final TextEditingController _agentPass = TextEditingController(text: 'agent123');
  final TextEditingController _agentBadge = TextEditingController(text: 'AGENT-CC-99');

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customerPhone.dispose();
    _customerPass.dispose();
    _riderPhone.dispose();
    _riderPass.dispose();
    _riderPlate.dispose();
    _partnerPhone.dispose();
    _partnerPass.dispose();
    _partnerTerminal.dispose();
    _agentPhone.dispose();
    _agentPass.dispose();
    _agentBadge.dispose();
    super.dispose();
  }

  void _handleLogin(String role) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (role == 'CUSTOMER') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Authenticated (tb user): Welcome to Customer App'),
          backgroundColor: Color(0xFFE1553C),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (role == 'RIDER') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🛵 Authenticated (secUser): Welcome to Rider Logistics Dashboard'),
          backgroundColor: Color(0xFF10B981),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RiderDashboardScreen()),
      );
    } else if (role == 'PARTNER') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🏪 Authenticated (secUser): Welcome to Restaurant Owner Dashboard'),
          backgroundColor: Color(0xFF3B82F6),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RestaurantDashboardScreen()),
      );
    } else if (role == 'AGENT') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎧 Authenticated (secUser): Welcome to Helpdesk Queue'),
          backgroundColor: Color(0xFF475569),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CallCenterDashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E24), Color(0xFF2A2A32)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE1553C), Color(0xFFFF8C61)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE1553C).withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🍔', style: TextStyle(fontSize: 38)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'FoodGo Platform',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '4 role workspace options below',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  ),
                  const SizedBox(height: 24),

                  // Login Card with TabBar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Role Tabs with 4 roles
                        Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F3F5),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            indicator: BoxDecoration(
                              color: const Color(0xFFE1553C),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: const Color(0xFF1E1E24),
                            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            tabs: const [
                              Tab(text: '👤 Customer'),
                              Tab(text: '🛵 Rider'),
                              Tab(text: '🏪 Partner'),
                              Tab(text: '🎧 Support'),
                            ],
                          ),
                        ),
                        
                        // Tab Content
                        SizedBox(
                          height: 380,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildForm(
                                phoneController: _customerPhone,
                                passController: _customerPass,
                                roleTitle: 'Customer Portal',
                                roleBadge: 'Access consumer workspace',
                                buttonText: 'Sign in as Customer',
                                extraFieldLabel: null,
                                extraFieldController: null,
                                onLogin: () => _handleLogin('CUSTOMER'),
                              ),
                              _buildForm(
                                phoneController: _riderPhone,
                                passController: _riderPass,
                                roleTitle: 'Rider Logistics',
                                roleBadge: 'Access fleet map & payouts',
                                buttonText: 'Sign in as Rider',
                                extraFieldLabel: 'Vehicle Plate Number',
                                extraFieldController: _riderPlate,
                                onLogin: () => _handleLogin('RIDER'),
                              ),
                              _buildForm(
                                phoneController: _partnerPhone,
                                passController: _partnerPass,
                                roleTitle: 'Restaurant Partner',
                                roleBadge: 'Access kitchen order board',
                                buttonText: 'Sign in as Partner',
                                extraFieldLabel: 'Kitchen Terminal Code',
                                extraFieldController: _partnerTerminal,
                                onLogin: () => _handleLogin('PARTNER'),
                              ),
                              _buildForm(
                                phoneController: _agentPhone,
                                passController: _agentPass,
                                roleTitle: 'Helpdesk Support',
                                roleBadge: 'Access unresolved SLA tickets',
                                buttonText: 'Sign in as Support',
                                extraFieldLabel: 'Agent Badge ID',
                                extraFieldController: _agentBadge,
                                onLogin: () => _handleLogin('AGENT'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Connected to Spring Boot API & MySQL',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm({
    required TextEditingController phoneController,
    required TextEditingController passController,
    required String roleTitle,
    required String roleBadge,
    required String buttonText,
    required String? extraFieldLabel,
    required TextEditingController? extraFieldController,
    required VoidCallback onLogin,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                roleTitle,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E24)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1553C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Demo Active',
                  style: TextStyle(color: Color(0xFFE1553C), fontSize: 11, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(roleBadge, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 14),
          
          // Phone Input
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone / Email',
              prefixIcon: const Icon(Icons.phone_android_rounded, size: 18, color: Color(0xFFE1553C)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          // Pass Input
          TextField(
            controller: passController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: Color(0xFFE1553C)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          // Optional Extra Role-Specific Field
          if (extraFieldLabel != null && extraFieldController != null) ...[
            const SizedBox(height: 12),
            TextField(
              controller: extraFieldController,
              decoration: InputDecoration(
                labelText: extraFieldLabel,
                prefixIcon: const Icon(Icons.security_rounded, size: 18, color: Color(0xFFE1553C)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE1553C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 2,
              ),
              onPressed: _isLoading ? null : onLogin,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(buttonText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}
