import 'package:hive_flutter/hive_flutter.dart';
import '../models/review.dart';

class ReviewData {
  // Get the Hive box
  static Box<Review> get _box => Hive.box<Review>('reviewsBox');

  // Get all reviews
  static List<Review> get allReviews {
    return _box.values.toList();
  }

  // Get reviews for a specific product
  static List<Review> getReviewsForProduct(String productName, String farmerName) {
    return _box.values
        .where((r) => r.productName == productName && r.farmerName == farmerName)
        .toList();
  }

  // Get average rating for a product
  static double getAverageRating(String productName, String farmerName) {
    final reviews = getReviewsForProduct(productName, farmerName);
    if (reviews.isEmpty) return 0.0;
    
    double total = 0;
    for (var review in reviews) {
      total += review.rating;
    }
    return total / reviews.length;
  }

  // Add a review
  static Future<void> addReview(Review review) async {
    await _box.add(review);
  }

  // Delete a review
  static Future<void> deleteReview(dynamic key) async {
    await _box.delete(key);
  }

  // Initialize with sample data if box is empty
  static Future<void> initializeSampleReviews() async {
    if (_box.isEmpty) {
      final sampleReviews = [
        Review(
          id: '1',
          productName: 'Tomatoes',
          farmerName: 'John Mutwiri',
          userName: 'Peter Mwenda',
          rating: 4.5,
          comment: 'Very fresh tomatoes! Will buy again.',
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Review(
          id: '2',
          productName: 'Tomatoes',
          farmerName: 'John Mutwiri',
          userName: 'Mary Kaari',
          rating: 5.0,
          comment: 'Best tomatoes in Meru!',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Review(
          id: '3',
          productName: 'Potatoes',
          farmerName: 'Mary Kaari',
          userName: 'John Mutwiri',
          rating: 4.0,
          comment: 'Good quality, fair price',
          date: DateTime.now().subtract(const Duration(hours: 12)),
        ),
      ];

      for (var review in sampleReviews) {
        await _box.add(review);
      }
    }
  }
}