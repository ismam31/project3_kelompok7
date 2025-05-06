import 'package:flutter/material.dart';
import '../layouts/bottom_navigation.dart';
import '../widgets/custom_drawer.dart';

class ListMenuPage extends StatelessWidget {
  const ListMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Menu"),
        backgroundColor: const Color(0xFF0492C2),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Menu Makanan & Minuman",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("Menu ${index + 1}"),
                    subtitle: Text("Harga: Rp ${index * 5000 + 15000}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Aksi edit menu
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 2),
    );
  }
}
