import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/produce.dart';
import '../models/cart_item.dart';
import '../models/review.dart';
import '../data/cart_data.dart';
import '../data/produce_data.dart';
import '../data/review_data.dart';
import '../data/auth_data.dart';
import 'cart_page.dart';

class BuyProducePage extends StatefulWidget {
  const BuyProducePage({super.key});

  @override
  State<BuyProducePage> createState() => _BuyProducePageState();
}

class _BuyProducePageState extends State<BuyProducePage> with TickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  
  List<Produce> allProduce = ProduceData.allProduce;
  List<Produce> filteredProduce = [];
  String? _selectedLocation;
  
  // Animation controllers
  late AnimationController _fadeController;
  
  int? _pressedIndex;

  @override
  void initState() {
    super.initState();
    filteredProduce = allProduce;
    
    // Setup fade animation for cards
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void searchProduce(String query) {
    _fadeController.reset();
    final results = allProduce.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase()) ||
             item.farmerName.toLowerCase().contains(query.toLowerCase()) ||
             item.farmerLocation.toLowerCase().contains(query.toLowerCase());
    }).toList();
    
    setState(() {
      filteredProduce = results;
    });
    _fadeController.forward();
  }

  void addToCart(Produce produce) {
    final existing = CartData.cartItems.where((item) => item.produce.name == produce.name);
    setState(() {
      if (existing.isNotEmpty) {
        existing.first.quantity++;
      } else {
        CartData.cartItems.add(CartItem(produce: produce, quantity: 1));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${produce.name} added to cart"), 
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void filterByLocation(String? location) {
    _fadeController.reset();
    setState(() {
      _selectedLocation = location;
      if (location == null) {
        filteredProduce = allProduce;
      } else {
        filteredProduce = allProduce.where((p) => p.farmerLocation == location).toList();
      }
    });
    _fadeController.forward();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (!mounted) return;
    
    _fadeController.reset();
    setState(() {
      filteredProduce = allProduce;
      searchController.clear();
      _selectedLocation = null;
    });
    _fadeController.forward();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Products refreshed!"),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Share function
  void _shareProduct(Produce produce) {
    Share.share(
      "🥬 Check out ${produce.name} from ${produce.farmerName} in ${produce.farmerLocation}! 🚜\n\n"
      "💰 Price: KSh ${produce.price} per ${produce.unit}\n"
      "⭐ Rating: ${produce.rating} stars\n\n"
      "Available on Meru Farm Market App! 🌾",
      subject: "Fresh produce from Meru County",
    );
  }

  // REVIEWS FUNCTIONS
  int _getReviewCount(String productName, String farmerName) {
    return ReviewData.getReviewsForProduct(productName, farmerName).length;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays > 7) {
      return "${date.day}/${date.month}/${date.year}";
    } else if (diff.inDays > 0) {
      return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago";
    } else {
      return "${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago";
    }
  }

  void _showReviewsDialog(Produce produce) {
    final reviews = ReviewData.getReviewsForProduct(produce.name, produce.farmerName);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Customer Reviews",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          produce.name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(
                          ReviewData.getAverageRating(produce.name, produce.farmerName).toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "(${reviews.length} reviews)",
                          // ignore: deprecated_member_use
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Add Review Button
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  onPressed: () => _addReviewDialog(produce),
                  icon: const Icon(Icons.rate_review),
                  label: const Text("Write a Review"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                ),
              ),
              
              // Reviews List
              Expanded(
                child: reviews.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text("No reviews yet. Be the first!", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.green.shade100,
                                        child: Text(review.userName[0]),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                            Row(
                                              children: List.generate(5, (i) => Icon(
                                                i < review.rating ? Icons.star : Icons.star_border,
                                                size: 14,
                                                color: Colors.amber,
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        _formatDate(review.date),
                                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(review.comment, style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addReviewDialog(Produce produce) {
    double ratingController = 4.0;
    final commentController = TextEditingController();
    final currentUser = AuthData.currentUser;
    
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: const Text("Write a Review"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Product: ${produce.name}", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Farmer: ${produce.farmerName}"),
                const SizedBox(height: 12),
                const Text("Your Rating:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => IconButton(
                    icon: Icon(
                      i < ratingController ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        ratingController = i + 1;
                      });
                    },
                  )),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Write your review here...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (commentController.text.isNotEmpty) {
                    final newReview = Review(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      productName: produce.name,
                      farmerName: produce.farmerName,
                      userName: currentUser?.name ?? "Anonymous",
                      rating: ratingController,
                      comment: commentController.text,
                      date: DateTime.now(),
                    );
                    await ReviewData.addReview(newReview);
                    if (mounted) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Review added!"), backgroundColor: Colors.green),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please write a comment"), backgroundColor: Colors.orange),
                    );
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buy Fresh Produce"),
        backgroundColor: Colors.green,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const CartPage()),
                ),
              ),
              if (CartData.cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${CartData.cartItems.length}', 
                      style: const TextStyle(color: Colors.white, fontSize: 10), 
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: searchProduce,
              decoration: InputDecoration(
                hintText: "Search by product, farmer, or location...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // LOCATION FILTER CHIPS
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildFilterChip("All", null),
                _buildFilterChip("Meru", "Meru"),
                _buildFilterChip("Timau", "Timau"),
                _buildFilterChip("Nkubu", "Nkubu"),
              ],
            ),
          ),

          // PRODUCE GRID WITH ANIMATIONS
          Expanded(
            child: RefreshIndicator(
              color: Colors.green,
              onRefresh: _handleRefresh,
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  mainAxisSpacing: 10, 
                  crossAxisSpacing: 10, 
                  childAspectRatio: 0.68,
                ),
                itemCount: filteredProduce.length,
                itemBuilder: (context, index) {
                  final produce = filteredProduce[index];
                  
                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 500 + (index * 100)),
                    child: GestureDetector(
                      onTapDown: (_) {
                        setState(() => _pressedIndex = index);
                      },
                      onTapUp: (_) {
                        setState(() => _pressedIndex = null);
                      },
                      onTapCancel: () {
                        setState(() => _pressedIndex = null);
                      },
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: _pressedIndex == index ? 0.98 : 1.0,
                        child: Card(
                          elevation: _pressedIndex == index ? 2 : 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // IMAGE
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                child: Image.asset(
                                  produce.image,
                                  height: 90,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image, size: 40),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product name
                                    Text(
                                      produce.name, 
                                      style: const TextStyle(
                                        fontSize: 15, 
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1, 
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    // Farmer name with icon
                                    Row(
                                      children: [
                                        const Icon(Icons.person, size: 12, color: Colors.green),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          child: Text(
                                            produce.farmerName,
                                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    // Location, Rating, and Reviews
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 10, color: Colors.red),
                                        const SizedBox(width: 2),
                                        Text(
                                          produce.farmerLocation,
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(Icons.star, size: 10, color: Colors.amber),
                                        Text(
                                          produce.rating.toStringAsFixed(1),
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 6),
                                        // REVIEWS BUTTON
                                        GestureDetector(
                                          onTap: () => _showReviewsDialog(produce),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.chat_bubble_outline, size: 10, color: Colors.grey),
                                                const SizedBox(width: 2),
                                                Text(
                                                  _getReviewCount(produce.name, produce.farmerName).toString(),
                                                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    
                                    // Price
                                    Text(
                                      "KSh ${produce.price} / ${produce.unit}", 
                                      style: const TextStyle(
                                        color: Colors.green, 
                                        fontSize: 13, 
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    
                                    // Stock
                                    Text(
                                      "Stock: ${produce.quantity} ${produce.unit}", 
                                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 6),
                                    
                                    // BUTTON ROW - Add to Cart and Share
                                    Row(
                                      children: [
                                        // Add to Cart button
                                        Expanded(
                                          flex: 2,
                                          child: ElevatedButton(
                                            onPressed: () => addToCart(produce),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green, 
                                              padding: const EdgeInsets.symmetric(vertical: 6),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text(
                                              "Add", 
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        // Share button
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.green.shade300),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: IconButton(
                                              icon: const Icon(Icons.share, size: 16, color: Colors.green),
                                              onPressed: () => _shareProduct(produce),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? location) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _selectedLocation == location,
        onSelected: (selected) {
          filterByLocation(selected ? location : null);
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.green,
        labelStyle: TextStyle(
          color: _selectedLocation == location ? Colors.white : Colors.black,
          fontSize: 12,
        ),
        elevation: 2,
        pressElevation: 4,
      ),
    );
  }
}