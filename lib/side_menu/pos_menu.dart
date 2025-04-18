import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const PosMenu());
}

class PosMenu extends StatelessWidget {
  const PosMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  void _showAddProductDialog(BuildContext context) {
    String name = '';
    String price = '';
    String imageUrl = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Produk'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                onChanged: (value) => price = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'URL Gambar'),
                onChanged: (value) => imageUrl = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && price.isNotEmpty) {
                  menuItems.add({
                    'name': name,
                    'price': int.tryParse(price) ?? 0,
                    'image':
                        imageUrl.isNotEmpty
                            ? imageUrl
                            : 'https://via.placeholder.com/150',
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077B6),
        title: Text(
          'Point Of Sale',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        leading: const Icon(Icons.menu_open_sharp, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit_square, color: Color(0xFF2c2c2c)),
                  onPressed: () => _showAddProductDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    ['Makanan', 'Minuman', 'Snack', 'Kopi'].map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(category, style: GoogleFonts.poppins()),
                          backgroundColor:
                              category == 'Makanan'
                                  ? Colors.black87
                                  : Colors.grey[200],
                          labelStyle: TextStyle(
                            color:
                                category == 'Makanan'
                                    ? Colors.white
                                    : Colors.black,
                          ),
                          avatar:
                              category == 'Makanan'
                                  ? const Icon(
                                    Icons.fastfood,
                                    color: Colors.white,
                                  )
                                  : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth >= 768 ? 3 : 2;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(menuItems.length, (index) {
                      final item = menuItems[index];
                      return MenuItemCard(item: item);
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const MenuItemCard({super.key, required this.item});

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: NetworkImage(widget.item['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item['name'],
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${widget.item['price']}',
                  style: GoogleFonts.montserrat(),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed:
                              quantity > 0
                                  ? () => setState(() => quantity--)
                                  : null,
                        ),
                        Text('$quantity'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setState(() => quantity++),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_checkout),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> menuItems = [
  {'name': 'Etong', 'price': 0, 'image': 'https://via.placeholder.com/150'},
  {'name': 'Kakap', 'price': 0, 'image': 'https://via.placeholder.com/150'},
  {
    'name': 'Bawal Bakar',
    'price': 0,
    'image': 'https://via.placeholder.com/150',
  },
  {
    'name': 'Ikan Merah',
    'price': 0,
    'image': 'https://via.placeholder.com/150',
  },
  {'name': 'Alamkao', 'price': 0, 'image': 'https://via.placeholder.com/150'},
  {
    'name': 'Talang-talang',
    'price': 0,
    'image': 'https://via.placeholder.com/150',
  },
];
