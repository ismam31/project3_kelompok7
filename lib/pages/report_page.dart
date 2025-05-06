import 'package:flutter/material.dart';
import '../layouts/bottom_navigation.dart';
import '../widgets/custom_drawer.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Keuangan"),
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
              "Laporan Penjualan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  title: Text("Total Penjualan"),
                  trailing: Text("Rp 500.000"),
                ),
                ListTile(
                  title: Text("Pengeluaran"),
                  trailing: Text("Rp 200.000"),
                ),
                ListTile(
                  title: Text("Keuntungan"),
                  trailing: Text("Rp 300.000"),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 3),
    );
  }
}
