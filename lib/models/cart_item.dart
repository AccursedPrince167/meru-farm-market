import 'produce.dart';

class CartItem {
  final Produce produce;
  int quantity;

  CartItem({
    required this.produce,
    required this.quantity,
  });

  double get totalPrice => produce.price * quantity;
}