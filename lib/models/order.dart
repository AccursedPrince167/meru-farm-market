// models/order.dart
import 'package:flutter/material.dart';
class Order {
  final String produceName;
  final int quantity;
  final String unit;
  final double totalPrice;
  String status;
  final DateTime orderDate;
  final String? farmerName;
  final String? farmerLocation;

  Order({
    required this.produceName,
    required this.quantity,
    required this.unit,
    required this.totalPrice,
    required this.status,
    required this.orderDate,
    this.farmerName,
    this.farmerLocation,
  });

  // Helper method to get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(orderDate);

    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "${difference.inDays} days ago";
    }
  }

  // Helper method to get color for status
  Color get statusColor {
    switch (status) {
      case "Delivered":
        return Colors.green;
      case "Shipped":
        return Colors.blue;
      case "Pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}