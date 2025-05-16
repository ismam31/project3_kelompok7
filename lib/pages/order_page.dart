import 'package:flutter/material.dart';
import '../layouts/bottom_navigation.dart';
import '../widgets/custom_drawer.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  String selectedCategory = 'Semua';
  final List<String> categories = [
    'Semua',
    'Makanan',
    'Minuman',
    'Snack',
    'Kopi',
  ];
  bool showCategoryFilter = false;
  int totalItems = 0;

  final Map<String, List<Map<String, dynamic>>> menuData = {
    'Makanan': [
      {
        'name': 'Etong Bakar',
        'price': '25000',
        'image': 'assets/images/etong.jpg',
        'quantity': 0,
      },
      {
        'name': 'Kakap Bakar',
        'price': '30000',
        'image': 'assets/images/etong.jpg',
        'quantity': 0,
      },
      {
        'name': 'Bawal Bakar',
        'price': '27000',
        'image': 'assets/images/etong.jpg',
        'quantity': 0,
      },
    ],
    'Minuman': [
      {
        'name': 'Es Teh Manis',
        'price': '5000',
        'image': 'assets/images/etong.jpg',
        'quantity': 0,
      },
      {
        'name': 'Es Jeruk',
        'price': '6000',
        'image': 'assets/images/etong.jpg',
        'quantity': 0,
      },
      {
        'name': 'Air Mineral',
        'price': '4000',
        'image': 'assets/images/etong.jpg',
        'quantity': 0,
      },
    ],
    'Snack': [
      {
        'name': 'Tahu Crispy',
        'price': '10000',
        'image': 'assets/images/etong.jpg',
        'quantity': 0,
      },
      {
        'name': 'Tempe Mendoan',
        'price': '9000',
        'image': 'assets/images/etong.jpg',
        'quantity': 0,
      },
      {
        'name': 'Udang Goreng',
        'price': '15000',
        'image': 'assets/images/etong.jpg',
        'quantity': 0,
      },
    ],
    'Kopi': [
      {
        'name': 'Kopi Hitam',
        'price': '8000',
        'image': 'assets/images/etong.jpg',
        'quantity': 0,
      },
      {
        'name': 'Kopi Susu',
        'price': '10000',
        'image': 'assets/images/etong.jpg',
        'quantity': 0,
      },
      {
        'name': 'Cappuccino',
        'price': '12000',
        'image': 'assets/images/etong.jpg',
        'quantity': 0,
      },
    ],
  };

  void _addToCart(String category, int index) {
    setState(() {
      menuData[category]![index]['quantity']++;
      totalItems++;
      _showAddToCartAnimation(context, index);
    });
  }

  void _showAddToCartAnimation(BuildContext context, int index) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    // Create animation controller with proper vsync
    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this, // Add 'with TickerProviderStateMixin' to your class
    )..forward();

    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut,
    );

    overlay.insert(
      OverlayEntry(
        builder:
            (context) => Positioned(
              left: position.dx + renderBox.size.width / 2,
              top: position.dy,
              child: Material(
                color: Colors.transparent,
                child: ScaleTransition(
                  scale: animation,
                  child: const Icon(Icons.shopping_cart, color: Colors.green),
                ),
              ),
            ),
      ),
    );

    // Clean up controller after animation completes
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      }
    });
  }

  List<Map<String, dynamic>> get filteredItems {
    if (selectedCategory == 'Semua') {
      return menuData.values.expand((list) => list).toList();
    }
    return menuData[selectedCategory]!;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;
    final items = filteredItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Point Of Sale"),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari menu...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_alt),
                  onPressed: () {
                    setState(() {
                      showCategoryFilter = !showCategoryFilter;
                    });
                  },
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        // Navigate to cart page
                      },
                    ),
                    if (totalItems > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$totalItems',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (showCategoryFilter) ...[
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
            ],
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
                  return GestureDetector(
                    onTap:
                        () => _addToCart(
                          item.containsKey('category')
                              ? item['category']
                              : selectedCategory,
                          index,
                        ),
                    child: ProductCard(
                      name: item['name'],
                      price: item['price'],
                      image: item['image'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: -1),
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
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 36),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text('Tambah Keranjang'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
