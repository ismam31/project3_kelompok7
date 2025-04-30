import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';
import '../layouts/bottom_navigation.dart'; // Import BottomNavigation

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    DashboardContent(), // dashboard content
    Center(child: Text("Halaman Pesanan")),
    Center(child: Text("Halaman Pesan")),
    Center(child: Text("Halaman Menu")),
    Center(child: Text("Halaman Laporan")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: const Color(0xFF0492C2),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF0492C2),
              ),
              child: Text(
                'Kasir Kuliner',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil Akun'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tentang Aplikasi'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // Aksi untuk tombol Pesan
        },
        shape: const CircleBorder(),
        child: const Icon(
          Icons.restaurant_menu,
          color: Color(0xFF0492C2),
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: const [
          DashboardCard(
            icon: Icons.shopping_cart,
            label: 'Barang Terjual',
            value: '125',
            color: Colors.green,
          ),
          DashboardCard(
            icon: Icons.attach_money,
            label: 'Total Pendapatan',
            value: 'Rp 3.500.000',
            color: Colors.blue,
          ),
          DashboardCard(
            icon: Icons.money_off,
            label: 'Total Pengeluaran',
            value: 'Rp 800.000',
            color: Colors.red,
          ),
          DashboardCard(
            icon: Icons.trending_up,
            label: 'Total Keuntungan',
            value: 'Rp 2.700.000',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}
