import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'pages/login_page.dart';
import 'adapters/hive_adapters.dart';
import 'models/produce.dart';
import 'models/user.dart';
import 'models/cart_item.dart';
import 'models/review.dart';
import 'data/produce_data.dart';
import 'data/auth_data.dart';
import 'data/review_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  
  // Register adapters
  Hive.registerAdapter(ProduceAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(UserRoleAdapter());
  Hive.registerAdapter(ReviewAdapter());
  
  // Open boxes
  await Hive.openBox<Produce>('produceBox');
  await Hive.openBox<User>('usersBox');
  await Hive.openBox<CartItem>('cartBox');
  await Hive.openBox<Review>('reviewsBox');
  
  // Initialize sample data if boxes are empty
  await ProduceData.initializeSampleData();
  await AuthData.initializeSampleUsers();
  await ReviewData.initializeSampleReviews();
  
  runApp(const FarmMarketApp());
}

class FarmMarketApp extends StatelessWidget {
  const FarmMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meru Farm Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      home: const LoginPage(),
    );
  }
}