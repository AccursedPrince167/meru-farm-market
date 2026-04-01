import 'models/produce.dart';

class CartItem {
  Produce produce;
  int quantity;

  CartItem({required this.produce, required this.quantity});
}

// Global cart list
List<CartItem> globalCart = [];