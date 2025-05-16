import 'package:flutter/material.dart';
import '../layouts/bottom_navigation.dart';
import '../widgets/custom_drawer.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String selectedCategory = 'Makanan';

  final List<String> categories = ['Makanan', 'Minuman', 'Snack', 'Kopi'];

  final Map<String, List<Map<String, String>>> menuData = {
    'Makanan': [
      {
        'name': 'Etong Bakar',
        'price': '25000',
        'image': 'assets/images/etong.jpg',
      },
      {
        'name': 'Kakap Bakar',
        'price': '30000',
        'image': 'assets/images/etong.jpg',
      },
      {
        'name': 'Bawal Bakar',
        'price': '27000',
        'image': 'assets/images/etong.jpg',
      },
    ],
    'Minuman': [
      {
        'name': 'Es Teh Manis',
        'price': '5000',
        'image': 'assets/images/etong.jpg',
      },
      {'name': 'Es Jeruk', 'price': '6000', 'image': 'assets/images/etong.jpg'},
      {
        'name': 'Air Mineral',
        'price': '4000',
        'image': 'assets/images/etong.jpg',
      },
    ],
    'Snack': [
      {
        'name': 'Tahu Crispy',
        'price': '10000',
        'image': 'assets/images/etong.jpg',
      },
      {
        'name': 'Tempe Mendoan',
        'price': '9000',
        'image': 'assets/images/etong.jpg',
      },
      {
        'name': 'Udang Goreng',
        'price': '15000',
        'image': 'assets/images/etong.jpg',
      },
    ],
    'Kopi': [
      {
        'name': 'Kopi Hitam',
        'price': '8000',
        'image': 'assets/images/etong.jpg',
      },
      {
        'name': 'Kopi Susu',
        'price': '10000',
        'image': 'assets/images/etong.jpg',
      },
      {
        'name': 'Cappuccino',
        'price': '12000',
        'image': 'assets/images/etong.jpg',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;
    final List<Map<String, String>> items = menuData[selectedCategory]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Point Of Sale"),
        backgroundColor: const Color(0xFF0492C2),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // aksi keranjang
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari menu...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((category) {
                      bool isSelected = selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          selectedColor: const Color(0xFF0492C2),
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ProductCard(
                    name: item['name']!,
                    price: item['price']!,
                    image: item['image']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: BottomNavigation(selectedIndex: -1),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String image;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp $price',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
