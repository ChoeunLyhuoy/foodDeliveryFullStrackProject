import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import '../models/chat_message.dart';

/// Central place for the backend base URL. For local dev on a real device,
/// replace 'localhost' with your machine's LAN IP (Android emulator: use
/// 10.0.2.2 instead of localhost).
class ApiConfig {
  static const String baseUrl = 'http://localhost:8080/api';
  static const String wsUrl = 'ws://localhost:8080/ws-native';
}

class ApiService {
  Future<List<Restaurant>> getRestaurants() async {
    final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/restaurants'));
    final List data = jsonDecode(res.body);
    return data.map((e) => Restaurant.fromJson(e)).toList();
  }

  Future<List<MenuItem>> getMenu(int restaurantId) async {
    final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/restaurants/$restaurantId/menu'));
    final List data = jsonDecode(res.body);
    return data.map((e) => MenuItem.fromJson(e)).toList();
  }

  Future<FoodOrder> createOrder({
    required int customerId,
    required int restaurantId,
    required String deliveryAddress,
    required List<Map<String, dynamic>> items,
  }) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'customerId': customerId,
        'restaurantId': restaurantId,
        'deliveryAddress': deliveryAddress,
        'items': items,
      }),
    );
    return FoodOrder.fromJson(jsonDecode(res.body));
  }

  Future<FoodOrder> getOrder(int orderId) async {
    final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/orders/$orderId'));
    return FoodOrder.fromJson(jsonDecode(res.body));
  }

  /// Powers the rider app's chat inbox: every active order assigned to this rider.
  Future<List<FoodOrder>> getActiveOrdersForRider(int riderId) async {
    final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/orders/rider/$riderId/active'));
    final List data = jsonDecode(res.body);
    return data.map((e) => FoodOrder.fromJson(e)).toList();
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/orders/$orderId/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );
  }

  Future<List<ChatMessage>> getRiderChatHistory(int orderId) async {
    final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/orders/$orderId/chat/rider'));
    final List data = jsonDecode(res.body);
    return data.map((e) => ChatMessage.fromJson(e)).toList();
  }

  Future<List<ChatMessage>> getCallCenterChatHistory(int orderId) async {
    final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/orders/$orderId/chat/call-center'));
    final List data = jsonDecode(res.body);
    return data.map((e) => ChatMessage.fromJson(e)).toList();
  }
}
