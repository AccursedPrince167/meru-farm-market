import 'package:hive_flutter/hive_flutter.dart';
import '../models/cart_item.dart';

class CartData {
  // Get the Hive box
  static Box<CartItem> get _box => Hive.box<CartItem>('cartBox');

  // Get all cart items as a list with their keys
  static List<CartItem> get cartItems {
    return _box.values.toList();
  }

  // Get all cart items with their keys (for operations that need keys)
  static Map<dynamic, CartItem> get cartItemsWithKeys {
    Map<dynamic, CartItem> items = {};
    for (var key in _box.keys) {
      items[key] = _box.get(key)!;
    }
    return items;
  }

  // Add item to cart
  static Future<void> addItem(CartItem item) async {
    await _box.add(item);
  }

  // Remove item by key
  static Future<void> removeItem(dynamic key) async {
    await _box.delete(key);
  }

  // Update existing item
  static Future<void> updateItem(dynamic key, CartItem item) async {
    await _box.put(key, item);
  }

  // Clear entire cart
  static Future<void> clearCart() async {
    await _box.clear();
  }

  // Get cart total
  static double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  // Get item count
  static int get itemCount {
    return cartItems.length;
  }
}