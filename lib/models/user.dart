enum UserRole { farmer, admin, buyer }

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? farmLocation; // For farmers
  final String? farmName;     // For farmers
  final DateTime joinDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.farmLocation,
    this.farmName,
    required this.joinDate,
  });

  // Helper to check role
  bool get isFarmer => role == UserRole.farmer;
  bool get isAdmin => role == UserRole.admin;
  bool get isBuyer => role == UserRole.buyer;
}