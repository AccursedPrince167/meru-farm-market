// lib/data/order_data.dart
import '../models/order.dart';

class OrderData {
  static List<Order> globalOrders = [
    // Sample order for demonstration
    Order(
      produceName: "Tomatoes",
      quantity: 3,
      unit: "kg",
      totalPrice: 240.00,
      status: "Pending",
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      farmerName: "John Mutwiri",
      farmerLocation: "Meru",
    ),
    Order(
      produceName: "Avocado",
      quantity: 5,
      unit: "pieces",
      totalPrice: 600.00,
      status: "Shipped",
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      farmerName: "Mary Kaari",
      farmerLocation: "Timau",
    ),
    Order(
      produceName: "Potatoes",
      quantity: 10,
      unit: "kg",
      totalPrice: 600.00,
      status: "Delivered",
      orderDate: DateTime.now().subtract(const Duration(days: 5)),
      farmerName: "Peter Mwenda",
      farmerLocation: "Nkubu",
    ),
  ];

  static void addOrder(Order order) {
    globalOrders.insert(0, order);
  }

  static void updateOrderStatus(int index, String newStatus) {
    if (index >= 0 && index < globalOrders.length) {
      globalOrders[index].status = newStatus;
    }
  }

  static List<Order> getOrdersByStatus(String status) {
    return globalOrders.where((order) => order.status == status).toList();
  }
}