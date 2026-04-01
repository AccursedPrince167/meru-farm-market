import 'package:flutter/material.dart';
import 'pages/buy_produce_page.dart';
import 'pages/cart_page.dart';
import 'pages/track_orders_page.dart';
import 'pages/admin_dashboard.dart';
import 'sell_produce.dart';
import 'home_page.dart';
import 'data/auth_data.dart';
import 'pages/login_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  late final List<Widget> _pages = [
    const HomePage(),
    const BuyProducePage(),
    const CartPage(),
    const SellProducePage(),
    const TrackOrdersPage(),
    if (AuthData.isAdmin) const AdminDashboard(),
  ];

  late final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    const BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: "Buy"),
    const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
    const BottomNavigationBarItem(icon: Icon(Icons.store), label: "Sell"),
    const BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: "Orders"),
    if (AuthData.isAdmin) 
      const BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: "Admin"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meru Farm Market"),
        backgroundColor: Colors.green,
        actions: [
          // Show user role
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AuthData.isAdmin ? 'Admin' : (AuthData.isFarmer ? 'Farmer' : 'Buyer'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        AuthData.logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navItems,
      ),
    );
  }
}