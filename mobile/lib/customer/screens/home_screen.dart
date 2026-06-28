import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../models/restaurant.dart';
import 'restaurant_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = ApiService();
  List<Restaurant> _restaurants = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getRestaurants();
      setState(() {
        _restaurants = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FoodGo')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _restaurants.length,
                itemBuilder: (context, i) {
                  final r = _restaurants[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(r.description),
                      trailing: Text('★ ${r.rating}'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurantId: r.id)),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
