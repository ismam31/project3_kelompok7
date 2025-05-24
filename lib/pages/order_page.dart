import 'package:flutter/material.dart';
import 'package:kasir_kuliner/pages/cart/cart_item_model.dart';
import 'package:kasir_kuliner/pages/cart/cart_screen.dart';
import 'package:kasir_kuliner/layouts/bottom_navigation.dart';
import 'package:kasir_kuliner/widgets/custom_drawer.dart';
import 'package:kasir_kuliner/pages/cart/order_model.dart';

class OrderPage extends StatefulWidget {
  final OrderModel existingOrder;
  const OrderPage({super.key, required this.existingOrder});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String selectedCategory = 'Semua';
  final List<String> categories = [
    'Semua',
    'Makanan',
    'Minuman',
    'Snack',
    'Kopi',
  ];
  bool showCategoryFilter = false;
  List<CartItemModel> cartItems = [];

  final Map<String, List<Map<String, dynamic>>> menuData = {
    'Makanan': [
      {
        'name': 'Etong Bakar',
        'price': 25000,
        'image': 'assets/images/etong.jpg',
      },
      {
        'name': 'Kakap Bakar',
        'price': 30000,
        'image': 'assets/images/etong.jpg',
      },
      {
        'name': 'Bawal Bakar',
        'price': 27000,
        'image': 'assets/images/etong.jpg',
      },
    ],
    'Minuman': [
      {
        'name': 'Es Teh Manis',
        'price': 5000,
        'image': 'assets/images/etong.jpg',
      },
      {'name': 'Es Jeruk', 'price': 6000, 'image': 'assets/images/etong.jpg'},
      {
        'name': 'Air Mineral',
        'price': 4000,
        'image': 'assets/images/etong.jpg',
      },
    ],
    'Snack': [
      {
        'name': 'Tahu Crispy',
        'price': 10000,
        'image': 'assets/images/etong.jpg',
      },
      {
        'name': 'Tempe Mendoan',
        'price': 9000,
        'image': 'assets/images/etong.jpg',
      },
      {
        'name': 'Udang Goreng',
        'price': 15000,
        'image': 'assets/images/etong.jpg',
      },
    ],
    'Kopi': [
      {'name': 'Kopi Hitam', 'price': 8000, 'image': 'assets/images/etong.jpg'},
      {'name': 'Kopi Susu', 'price': 10000, 'image': 'assets/images/etong.jpg'},
      {
        'name': 'Cappuccino',
        'price': 12000,
        'image': 'assets/images/etong.jpg',
      },
    ],
  };

  void _addToCart(String category, int index) {
    final item = menuData[category]![index];
    final existingItemIndex = cartItems.indexWhere(
      (cartItem) => cartItem.id == '${category}_$index',
    );

    setState(() {
      if (existingItemIndex >= 0) {
        cartItems[existingItemIndex].incrementQuantity();
      } else {
        cartItems.add(
          CartItemModel(
            id: '${category}_$index',
            name: item['name'],
            price: item['price'],
            image: item['image'],
          ),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} ditambahkan ke keranjang'),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _increaseItem(CartItemModel item) {
    setState(() {
      item.incrementQuantity();
    });
  }

  void _decreaseItem(CartItemModel item) {
    setState(() {
      if (item.quantity > 1) {
        item.decrementQuantity();
      } else {
        cartItems.remove(item);
      }
    });
  }

  void _removeItem(CartItemModel item) {
    setState(() {
      cartItems.remove(item);
    });
  }

  void _clearCart() {
    setState(() {
      cartItems.clear();
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
                const SizedBox(width: 10),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, size: 30),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CartScreen(
                                  cartItems: cartItems,
                                  onIncrease: _increaseItem,
                                  onDecrease: _decreaseItem,
                                  onRemove: _removeItem,
                                  onClear: _clearCart,
                                ),
                          ),
                        );
                      },
                    ),
                    if (cartItems.isNotEmpty)
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
                            '${cartItems.fold(0, (sum, item) => sum + item.quantity)}',
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
                    name: item['name'],
                    price: item['price'].toString(),
                    image: item['image'],
                    onAddToCart:
                        () => _addToCart(
                          selectedCategory == 'Semua'
                              ? _findCategory(item['name'])
                              : selectedCategory,
                          index,
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

  String _findCategory(String itemName) {
    for (var category in menuData.keys) {
      if (menuData[category]!.any((item) => item['name'] == itemName)) {
        return category;
      }
    }
    return 'Makanan';
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String image;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.onAddToCart,
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
                  onPressed: onAddToCart,
                  child: const Text('Tambah ke Keranjang'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
