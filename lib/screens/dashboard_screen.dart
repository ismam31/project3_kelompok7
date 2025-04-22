import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Color(0xFF0492C2),
      ),
      body: Padding(
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
      ),
    );
  }
}
