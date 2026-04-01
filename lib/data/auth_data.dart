import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

class AuthData {
  static User? _currentUser;
  
  // Get the Hive box
  static Box<User> get _box => Hive.box<User>('usersBox');

  static User? get currentUser => _currentUser;
  static bool get isLoggedIn => _currentUser != null;
  static bool get isAdmin => _currentUser?.isAdmin ?? false;
  static bool get isFarmer => _currentUser?.isFarmer ?? false;

  static Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      // Find user by email (in real app, check password too)
      final user = _box.values.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
      
      _currentUser = user;
      return true;
    } catch (e) {
      // User not found
      return false;
    }
  }

  static void logout() {
    _currentUser = null;
  }

  static Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required UserRole role,
    String? farmLocation,
    String? farmName,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Check if email already exists
    final exists = _box.values.any((u) => u.email.toLowerCase() == email.toLowerCase());
    if (exists) return false;
    
    // Create new user with simple ID (using timestamp + random)
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
      role: role,
      farmLocation: farmLocation,
      farmName: farmName,
      joinDate: DateTime.now(),
    );
    
    await _box.add(newUser);
    _currentUser = newUser;
    return true;
  }

  static List<User> getAllFarmers() {
    return _box.values.where((u) => u.role == UserRole.farmer).toList();
  }

  static List<User> getAllBuyers() {
    return _box.values.where((u) => u.role == UserRole.buyer).toList();
  }

  static List<User> getAllUsers() {
    return _box.values.toList();
  }

  // Initialize with sample users if box is empty
  static Future<void> initializeSampleUsers() async {
    if (_box.isEmpty) {
      final sampleUsers = [
        User(
          id: '1',
          name: 'John Mutwiri',
          email: 'john@merufarm.co.ke',
          phone: '0712345678',
          role: UserRole.farmer,
          farmLocation: 'Meru',
          farmName: 'Mutwiri Fresh Farms',
          joinDate: DateTime.now().subtract(const Duration(days: 30)),
        ),
        User(
          id: '2',
          name: 'Mary Kaari',
          email: 'mary@timaufarm.co.ke',
          phone: '0723456789',
          role: UserRole.farmer,
          farmLocation: 'Timau',
          farmName: 'Kaari Organic',
          joinDate: DateTime.now().subtract(const Duration(days: 15)),
        ),
        User(
          id: '3',
          name: 'Admin User',
          email: 'admin@merumarket.co.ke',
          phone: '0700000000',
          role: UserRole.admin,
          joinDate: DateTime.now(),
        ),
        User(
          id: '4',
          name: 'Peter Mwenda',
          email: 'peter@gmail.com',
          phone: '0734567890',
          role: UserRole.buyer,
          joinDate: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];

      for (var user in sampleUsers) {
        await _box.add(user);
      }
    }
  }
}