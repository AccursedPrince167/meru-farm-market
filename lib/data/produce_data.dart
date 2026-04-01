import 'package:hive_flutter/hive_flutter.dart';
import '../models/produce.dart';

class ProduceData {
  // Get the Hive box
  static Box<Produce> get _box => Hive.box<Produce>('produceBox');

  // Get all produce as a list
  static List<Produce> get allProduce {
    return _box.values.toList();
  }

  // Add new produce
  static Future<void> addProduce(Produce item) async {
    await _box.add(item);
  }

  // Delete produce by key
  static Future<void> deleteProduce(dynamic key) async {
    await _box.delete(key);
  }

  // Update existing produce
  static Future<void> updateProduce(dynamic key, Produce item) async {
    await _box.put(key, item);
  }

  // Get produce by location
  static List<Produce> getProduceByLocation(String location) {
    return _box.values.where((p) => p.farmerLocation == location).toList();
  }

  // Get produce by farmer name
  static List<Produce> getProduceByFarmer(String farmerName) {
    return _box.values.where((p) => p.farmerName == farmerName).toList();
  }

  // Search produce
  static List<Produce> searchProduce(String query) {
    if (query.isEmpty) return allProduce;
    
    return _box.values.where((produce) {
      return produce.name.toLowerCase().contains(query.toLowerCase()) ||
             produce.farmerName.toLowerCase().contains(query.toLowerCase()) ||
             produce.farmerLocation.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Initialize with sample data if box is empty
  static Future<void> initializeSampleData() async {
    if (_box.isEmpty) {
      final sampleProduce = [
        Produce(
          name: "Tomatoes", 
          price: 80, 
          unit: "kg", 
          quantity: 50,
          image: "assets/images/tomatoes.jpg",
          farmerName: "John Mutwiri",
          farmerLocation: "Meru",
          rating: 4.5,
        ),
        Produce(
          name: "Potatoes", 
          price: 60, 
          unit: "kg", 
          quantity: 80,
          image: "assets/images/potatoes.jpg",
          farmerName: "Mary Kaari",
          farmerLocation: "Timau",
          rating: 4.8,
        ),
        Produce(
          name: "Carrots", 
          price: 70, 
          unit: "kg", 
          quantity: 40,
          image: "assets/images/carrots.jpg",
          farmerName: "Peter Mwenda",
          farmerLocation: "Nkubu",
          rating: 4.2,
        ),
        Produce(
          name: "Cabbage", 
          price: 50, 
          unit: "piece", 
          quantity: 30,
          image: "assets/images/cabbage.jpg",
          farmerName: "Susan Kiambi",
          farmerLocation: "Meru",
          rating: 4.0,
        ),
        Produce(
          name: "Onions", 
          price: 90, 
          unit: "kg", 
          quantity: 60,
          image: "assets/images/onions.jpg",
          farmerName: "James Muthomi",
          farmerLocation: "Timau",
          rating: 4.3,
        ),
        Produce(
          name: "Avocado", 
          price: 120, 
          unit: "piece", 
          quantity: 45,
          image: "assets/images/avocado.jpg",
          farmerName: "Grace Kawira",
          farmerLocation: "Nkubu",
          rating: 4.7,
        ),
      ];

      for (var produce in sampleProduce) {
        await _box.add(produce);
      }
    }
  }
}