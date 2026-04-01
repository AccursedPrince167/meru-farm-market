import 'package:flutter/material.dart';
import 'models/produce.dart';
import 'data/produce_data.dart';
import 'package:flutter/services.dart';

class SellProducePage extends StatefulWidget {
  const SellProducePage({super.key});

  @override
  State<SellProducePage> createState() => _SellProducePageState();
}

class _SellProducePageState extends State<SellProducePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _farmerNameController = TextEditingController();
  
  String? _selectedImage;
  String? _selectedLocation;
  double _rating = 4.0;
  
  final List<String> imageOptions = [
    'tomatoes.jpg',
    'potatoes.jpg',
    'carrots.jpg',
    'cabbage.jpg',
    'onions.jpg',
    'avocado.jpg',
    'miraa.jpg',
  ];

  final List<String> locationOptions = ['Meru', 'Timau', 'Nkubu','Maua'];

  List<Produce> farmerProduce = [];

  void addProduce() {HapticFeedback.mediumImpact();
    if (_formKey.currentState!.validate()) {
      final produce = Produce(
        name: _nameController.text,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        unit: _unitController.text,
        image: 'assets/images/$_selectedImage',
        farmerName: _farmerNameController.text,
        farmerLocation: _selectedLocation!,
        rating: _rating,
      );

      // Add to shared data (for Buy page)
      ProduceData.addProduce(produce);
      
      // Also add to local list (for Sell page display)
      setState(() {
        farmerProduce.add(produce);
        _nameController.clear();
        _priceController.clear();
        _quantityController.clear();
        _unitController.clear();
        _farmerNameController.clear();
        _selectedImage = null;
        _selectedLocation = null;
        _rating = 4.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Produce added successfully! It will appear in Buy page."),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sell Your Produce"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Produce Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Produce Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.agriculture),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter a name" : null,
                  ),
                  const SizedBox(height: 12),

                  // Price
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Price (KES per unit)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Enter price";
                      if (double.tryParse(value) == null) return "Enter valid number";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Quantity
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Enter quantity";
                      if (int.tryParse(value) == null) return "Enter valid whole number";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Unit
                  TextFormField(
                    controller: _unitController,
                    decoration: const InputDecoration(
                      labelText: "Unit (kg, pieces, etc.)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.scale),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter unit" : null,
                  ),
                  const SizedBox(height: 12),

                  // Farmer Name
                  TextFormField(
                    controller: _farmerNameController,
                    decoration: const InputDecoration(
                      labelText: "Farmer Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter farmer name" : null,
                  ),
                  const SizedBox(height: 12),

                  // Image Dropdown - FIXED
                  DropdownButtonFormField<String>(
                    // ignore: deprecated_member_use
                    value: _selectedImage,
                    decoration: const InputDecoration(
                      labelText: "Select Image",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.image),
                    ),
                    hint: const Text("Choose an image"),
                    items: imageOptions.map((image) {
                      return DropdownMenuItem(
                        value: image,
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              margin: const EdgeInsets.only(right: 8),
                              child: Image.asset(
                                'assets/images/$image',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => 
                                  const Icon(Icons.broken_image, size: 20),
                              ),
                            ),
                            Text(image.replaceAll('.jpg', '')),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedImage = value;
                      });
                    },
                    validator: (value) => value == null ? "Select an image" : null,
                  ),
                  const SizedBox(height: 12),

                  // Location Dropdown - FIXED
                  DropdownButtonFormField<String>(
                    // ignore: deprecated_member_use
                    value: _selectedLocation,
                    decoration: const InputDecoration(
                      labelText: "Farmer Location",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    hint: const Text("Select location"),
                    items: locationOptions.map((location) {
                      return DropdownMenuItem(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLocation = value;
                      });
                    },
                    validator: (value) => value == null ? "Select location" : null,
                  ),
                  const SizedBox(height: 12),

                  // Rating Slider
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Rating (1-5 stars)", style: TextStyle(fontSize: 14)),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _rating,
                              min: 1.0,
                              max: 5.0,
                              divisions: 8,
                              activeColor: Colors.green,
                              onChanged: (value) {
                                setState(() {
                                  _rating = value;
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.withAlpha(26),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  _rating.toStringAsFixed(1),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: addProduce,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        "Add Produce",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Farmer's Listed Produce
            farmerProduce.isEmpty
                ? const Center(
                    child: Column(
                      children: [
                        Icon(Icons.store, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          "No produce added yet",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          "Use the form above to list your produce",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "My Listed Produce",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: farmerProduce.length,
                        itemBuilder: (context, index) {
                          final produce = farmerProduce[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  produce.image,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                ),
                              ),
                              title: Text(
                                produce.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${produce.quantity} ${produce.unit} - KES ${produce.price.toStringAsFixed(2)}"),
                                  Text("${produce.farmerName} • ${produce.farmerLocation} • ⭐ ${produce.rating.toStringAsFixed(1)}",
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () { HapticFeedback.heavyImpact(); 
                                  setState(() {
                                    farmerProduce.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Produce removed"),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}