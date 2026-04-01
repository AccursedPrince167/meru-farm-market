import 'package:flutter/material.dart';
import 'pages/buy_produce_page.dart';
import 'pages/cart_page.dart';
import 'pages/track_orders_page.dart';
import 'sell_produce.dart';

void main() {
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meru Farm Market"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FARM BANNER
            Container(
              margin: const EdgeInsets.all(12),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1501004318641-b39e6451bec6",
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black.withAlpha(90),
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Fresh From Farmers\nDirect to You",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // QUICK ACTIONS TITLE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // QUICK ACTIONS BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // BUY PRODUCE
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BuyProducePage(),
                      ),
                    );
                  },
                  child: actionCard(
                    icon: Icons.shopping_basket,
                    label: "Buy Produce",
                    color: Colors.green,
                  ),
                ),

                // SELL PRODUCE
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SellProducePage(),
                      ),
                    );
                  },
                  child: actionCard(
                    icon: Icons.store,
                    label: "Sell Produce",
                    color: Colors.blue,
                  ),
                ),

                // CART
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartPage(),
                      ),
                    );
                  },
                  child: actionCard(
                    icon: Icons.shopping_cart,
                    label: "My Cart",
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // FEATURED PRODUCE TITLE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Featured Produce",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // FEATURED PRODUCE SCROLLER
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  ProduceCard(name: "Tomatoes", image: "assets/images/tomatoes.jpg"),
                  ProduceCard(name: "Avocado", image: "assets/images/avocado.jpg"),
                  ProduceCard(name: "Carrots", image: "assets/images/carrots.jpg"),
                  ProduceCard(name: "Cabbage", image: "assets/images/cabbage.jpg"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // TRACK ORDERS BUTTON
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrackOrdersPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.local_shipping),
                label: const Text("Track My Orders"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ACTION BUTTON CARD
Widget actionCard({
  required IconData icon,
  required String label,
  required Color color,
}) {
  return Container(
    width: 110,
    height: 120,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
        )
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: color),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

// FEATURED PRODUCE CARD
class ProduceCard extends StatelessWidget {
  final String name;
  final String image;
  const ProduceCard({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withAlpha(90),
        ),
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}