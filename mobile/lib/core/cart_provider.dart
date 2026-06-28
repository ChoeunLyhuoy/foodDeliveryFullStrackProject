import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class CartLine {
  final MenuItem item;
  int quantity;
  CartLine(this.item, this.quantity);
}

class CartProvider extends ChangeNotifier {
  int? restaurantId;
  final List<CartLine> _lines = [];

  List<CartLine> get lines => _lines;

  double get total => _lines.fold(0, (sum, l) => sum + l.item.price * l.quantity);

  void addItem(int restaurantId, MenuItem item) {
    if (this.restaurantId != null && this.restaurantId != restaurantId) {
      _lines.clear(); // switching restaurants clears the cart
    }
    this.restaurantId = restaurantId;
    CartLine? existing;
    for (final l in _lines) {
      if (l.item.id == item.id) {
        existing = l;
        break;
      }
    }
    if (existing != null) {
      existing.quantity++;
    } else {
      _lines.add(CartLine(item, 1));
    }
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    restaurantId = null;
    notifyListeners();
  }
}
