// models/produce.dart
class Produce {
  final String name;
  final double price;
  final String unit;
  final int quantity;
  final String image;
  final String farmerName;
  final String farmerLocation;
  final double rating;

  Produce({
    required this.name,
    required this.price,
    required this.unit,
    required this.quantity,
    required this.image,
    required this.farmerName,
    required this.farmerLocation,
    required this.rating,
  });
}