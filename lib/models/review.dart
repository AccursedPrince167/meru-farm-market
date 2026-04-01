class Review {
  final String id;
  final String productName;
  final String farmerName;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.productName,
    required this.farmerName,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}