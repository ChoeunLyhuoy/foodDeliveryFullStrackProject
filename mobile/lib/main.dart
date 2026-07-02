import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/cart_provider.dart';
import 'customer/screens/home_screen.dart';
import 'rider/screens/rider_dashboard_screen.dart';

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
  
  // 2 sets of controllers (restricting to Customer and Delivery Rider only)
  final TextEditingController _customerPhone = TextEditingController(text: '+855 12 345 678');
  final TextEditingController _customerPass = TextEditingController(text: 'customer123');

  final TextEditingController _riderPhone = TextEditingController(text: '+855 98 765 432');
  final TextEditingController _riderPass = TextEditingController(text: 'rider123');
  final TextEditingController _riderPlate = TextEditingController(text: 'PP-1A-8888');

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customerPhone.dispose();
    _customerPass.dispose();
    _riderPhone.dispose();
    _riderPass.dispose();
    _riderPlate.dispose();
    super.dispose();
  }

  void _showCustomAlert(BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withAlpha(210)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'System Notification',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin(String role) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (role == 'CUSTOMER') {
      _showCustomAlert(
        context,
        'Authenticated (tb user): Welcome to Customer App',
        const Color(0xFFE1553C),
        Icons.check_circle_outline_rounded,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (role == 'RIDER') {
      _showCustomAlert(
        context,
        'Authenticated (secUser): Welcome to Rider Logistics Dashboard',
        const Color(0xFF10B981),
        Icons.delivery_dining_rounded,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RiderDashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Premium Dark Gradient Background
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0F1117),
            ),
          ),
          // Glowing Blur Orb 1 (Top Left)
          Positioned(
            top: -120,
            left: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE1553C).withOpacity(0.15),
              ),
            ),
          ),
          // Glowing Blur Orb 2 (Bottom Right)
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF10B981).withOpacity(0.1),
              ),
            ),
          ),
          // Real Content Scroll Area
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Logo Widget
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE1553C), Color(0xFFFF7E61)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE1553C).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🍔', style: TextStyle(fontSize: 42)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'FoodGo Mobile',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Customer & Rider workspace roles only',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 32),

                    // Login Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 35,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Custom SlidTab Selector
                          Container(
                            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F3F5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFE1553C), Color(0xFFFF6B4A)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: const Color(0xFF1E1E24),
                              labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                              tabs: const [
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person_outline_rounded, size: 16),
                                      SizedBox(width: 6),
                                      Text('Customer'),
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.delivery_dining_rounded, size: 16),
                                      SizedBox(width: 6),
                                      Text('Rider'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Tab Contents
                          SizedBox(
                            height: 360,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Secure Connection · Spring Boot Mobile API',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                roleTitle,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E24)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1553C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Demo Active',
                  style: TextStyle(color: Color(0xFFE1553C), fontSize: 11, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(roleBadge, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 20),
          
          // Phone Input
          TextField(
            controller: phoneController,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Phone / Email',
              prefixIcon: const Icon(Icons.phone_android_rounded, size: 20, color: Color(0xFFE1553C)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE1553C), width: 1.8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 14),
          // Pass Input
          TextField(
            controller: passController,
            obscureText: true,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: Color(0xFFE1553C)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE1553C), width: 1.8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          // Optional Extra Role-Specific Field
          if (extraFieldLabel != null && extraFieldController != null) ...[
            const SizedBox(height: 14),
            TextField(
              controller: extraFieldController,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              decoration: InputDecoration(
                labelText: extraFieldLabel,
                prefixIcon: const Icon(Icons.security_rounded, size: 20, color: Color(0xFFE1553C)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE1553C), width: 1.8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE1553C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                shadowColor: const Color(0xFFE1553C).withOpacity(0.3),
              ),
              onPressed: _isLoading ? null : onLogin,
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(buttonText, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.2)),
            ),
          ),
        ],
      ),
    );
  }
}
