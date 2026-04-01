import 'package:flutter/material.dart';
import '../data/auth_data.dart';
import '../models/user.dart';
import '../data/produce_data.dart';
import '../models/produce.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Stats cards data
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is admin
    if (!AuthData.isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Access Denied"),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.block, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                "Admin Access Only",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "You don't have permission to view this page",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: "Overview"),
            Tab(icon: Icon(Icons.people), text: "Farmers"),
            Tab(icon: Icon(Icons.shopping_basket), text: "Products"),
            Tab(icon: Icon(Icons.settings), text: "Settings"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Overview Tab
          _buildOverviewTab(),
          
          // Farmers Tab
          _buildFarmersTab(),
          
          // Products Tab
          _buildProductsTab(),
          
          // Settings Tab
          _buildSettingsTab(),
        ],
      ),
    );
  }

  // OVERVIEW TAB
  Widget _buildOverviewTab() {
    final farmers = AuthData.getAllFarmers();
    final products = ProduceData.allProduce;
    final buyers = AuthData.getAllBuyers();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards
          Row(
            children: [
              _buildStatCard(
                "Total Farmers", 
                farmers.length.toString(), 
                Icons.people, 
                Colors.blue,
              ),
              const SizedBox(width: 10),
              _buildStatCard(
                "Total Products", 
                products.length.toString(), 
                Icons.shopping_basket, 
                Colors.green,
              ),
              const SizedBox(width: 10),
              _buildStatCard(
                "Total Buyers", 
                buyers.length.toString(), 
                Icons.person, 
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Activity
          const Text(
            "Recent Activity",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person_add, color: Colors.white),
                  ),
                  title: const Text("New Farmer Registered"),
                  subtitle: Text("John Mutwiri joined as farmer"),
                  trailing: Text("2 min ago"),
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                  title: const Text("New Product Added"),
                  subtitle: Text("Tomatoes listed by Mary Kaari"),
                  trailing: Text("1 hour ago"),
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.local_shipping, color: Colors.white),
                  ),
                  title: const Text("Order Completed"),
                  subtitle: Text("Order #1234 delivered"),
                  trailing: Text("3 hours ago"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // FARMERS TAB
  Widget _buildFarmersTab() {
    final farmers = AuthData.getAllFarmers();
    
    return farmers.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text("No farmers registered yet"),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: farmers.length,
            itemBuilder: (context, index) {
              final farmer = farmers[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(farmer.name[0]),
                  ),
                  title: Text(farmer.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(farmer.email),
                      Text("${farmer.farmName ?? 'No farm'} • ${farmer.farmLocation ?? 'No location'}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editFarmer(farmer),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteFarmer(farmer),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  // PRODUCTS TAB
  Widget _buildProductsTab() {
    final products = ProduceData.allProduce;
    
    return products.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text("No products listed yet"),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  title: Text(product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${product.farmerName} • ${product.farmerLocation}"),
                      Text("KSh ${product.price} / ${product.unit} • Stock: ${product.quantity}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editProduct(product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduct(product),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  // SETTINGS TAB
  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "App Settings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        
        // Settings options
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text("Maintenance Mode"),
                subtitle: const Text("Disable app for updates"),
                value: false,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Feature coming soon")),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text("Push Notifications"),
                subtitle: const Text("Configure notification settings"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Feature coming soon")),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text("App Theme"),
                subtitle: const Text("Customize app appearance"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Feature coming soon")),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        const Text(
          "User Management",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_add, color: Colors.green),
                title: const Text("Create Admin"),
                subtitle: const Text("Add new admin user"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Feature coming soon")),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text("Block User"),
                subtitle: const Text("Suspend user account"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Feature coming soon")),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        const Text(
          "Data Management",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.backup, color: Colors.blue),
                title: const Text("Backup Database"),
                subtitle: const Text("Export all data"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Feature coming soon")),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.restore, color: Colors.orange),
                title: const Text("Restore Database"),
                subtitle: const Text("Import from backup"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Feature coming soon")),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper methods
  void _editFarmer(User farmer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Farmer"),
        content: const Text("Edit functionality coming soon"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _deleteFarmer(User farmer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Farmer"),
        content: Text("Are you sure you want to delete ${farmer.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // In a real app, you'd remove from database
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${farmer.name} deleted"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _editProduct(Produce product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Product"),
        content: const Text("Edit functionality coming soon"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(Produce product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product"),
        content: Text("Are you sure you want to delete ${product.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // In a real app, you'd remove from database
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${product.name} deleted"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}