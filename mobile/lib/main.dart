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
        title: 'FoodGo',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFFE1553C),
          scaffoldBackgroundColor: const Color(0xFFFAF7F2),
        ),
        home: const RoleChooserScreen(),
      ),
    );
  }
}

/// This single Flutter codebase contains BOTH the Customer app and the
/// Rider app (as described in the project brief). In production these
/// would typically ship as two separate app bundles/flavors; this screen
/// is just a convenience switcher for running the demo.
class RoleChooserScreen extends StatelessWidget {
  const RoleChooserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('FoodGo', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFFE1553C))),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen())),
              child: const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), child: Text('Continue as Customer')),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RiderDashboardScreen())),
              child: const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), child: Text('Continue as Rider')),
            ),
          ],
        ),
      ),
    );
  }
}
