import 'package:flutter/material.dart';
import '../../data/order_data.dart';
import '../../models/order.dart';

class TrackOrdersPage extends StatefulWidget {
  const TrackOrdersPage({super.key});

  @override
  State<TrackOrdersPage> createState() => _TrackOrdersPageState();
}

class _TrackOrdersPageState extends State<TrackOrdersPage> {
  String _selectedFilter = "All"; // For filtering orders

  List<Order> get filteredOrders {
    if (_selectedFilter == "All") {
      return OrderData.globalOrders;
    } else {
      return OrderData.globalOrders
          .where((order) => order.status == _selectedFilter)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Orders"),
        backgroundColor: Colors.green,
        actions: [
          // Filter dropdown (NEW but optional - you can remove if you want)
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "All", child: Text("All Orders")),
              const PopupMenuItem(value: "Pending", child: Text("Pending")),
              const PopupMenuItem(value: "Shipped", child: Text("Shipped")),
              const PopupMenuItem(value: "Delivered", child: Text("Delivered")),
            ],
          ),
        ],
      ),
      body: OrderData.globalOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No orders placed yet",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your orders will appear here",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("Go Shopping"),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Filter chips (optional)
                if (OrderData.globalOrders.isNotEmpty)
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterChip("All"),
                        _buildFilterChip("Pending"),
                        _buildFilterChip("Shipped"),
                        _buildFilterChip("Delivered"),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Order header with date
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order.formattedDate,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: order.statusColor.withAlpha(26),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: order.statusColor,
                                      ),
                                    ),
                                    child: Text(
                                      order.status,
                                      style: TextStyle(
                                        color: order.statusColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              /// Produce name and quantity - YOUR ORIGINAL FORMAT PRESERVED
                              Text(
                                order.produceName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Quantity: ${order.quantity} ${order.unit}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),

                              /// Farmer info (new but won't break anything)
                              if (order.farmerName != null)
                                Row(
                                  children: [
                                    const Icon(Icons.person, size: 14, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text(
                                      order.farmerName!,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              if (order.farmerLocation != null)
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 14, color: Colors.red),
                                    const SizedBox(width: 4),
                                    Text(
                                      order.farmerLocation!,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 4),

                              /// Total price - YOUR ORIGINAL FORMAT
                              Text(
                                "Total: KES ${order.totalPrice.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),

                              /// YOUR ORIGINAL POPUPMENUBUTTON - KEPT EXACTLY
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Update Status: ",
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      setState(() {
                                        order.status = value;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Status updated to $value"),
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'Pending',
                                        child: Text('Pending'),
                                      ),
                                      PopupMenuItem(
                                        value: 'Shipped',
                                        child: Text('Shipped'),
                                      ),
                                      PopupMenuItem(
                                        value: 'Delivered',
                                        child: Text('Delivered'),
                                      ),
                                    ],
                                    icon: const Icon(Icons.more_vert),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: _selectedFilter == label,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.green,
        labelStyle: TextStyle(
          color: _selectedFilter == label ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}