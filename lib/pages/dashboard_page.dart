import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';
import '../layouts/bottom_navigation.dart';
import '../widgets/custom_drawer.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Dashboard"),
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
      body: const DashboardContent(),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 0),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk grafik
    final salesData = [10.0, 12.0, 18.0, 14.0, 20.0, 22.0, 25.0];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
        childAspectRatio: 1.2, // Lebih tinggi untuk grafik
        children: [
          DashboardCard(
            icon: Icons.shopping_cart,
            label: 'Barang Terjual',
            value: '125',
            color: Colors.green,
            delay: 0,
          ),
          DashboardCard(
            icon: Icons.attach_money,
            label: 'Total Pendapatan',
            value: 'Rp 3.500.000',
            color: Colors.blue,
            delay: 0.2,
          ),
          DashboardCard(
            icon: Icons.money_off,
            label: 'Total Pengeluaran',
            value: 'Rp 800.000',
            color: Colors.red,
            delay: 0.4,
          ),
          DashboardCard(
            icon: Icons.trending_up,
            label: 'Trend Penjualan',
            color: Colors.orange,
            delay: 0.6,
            child: MiniLineChart(data: salesData), // Pakai grafik
          ),
          DashboardCard(
            icon: Icons.pie_chart,
            label: 'Kategori Terlaris',
            color: Colors.purple,
            delay: 0.8,
            child: const Text("Makanan 70%"), // Bisa diganti grafik pie
          ),
          DashboardCard(
            icon: Icons.star,
            label: 'Rating Hari Ini',
            value: '4.8/5',
            color: Colors.amber,
            delay: 1.0,
          ),
        ],
      ),
    );
  }
}
