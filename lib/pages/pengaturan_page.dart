import 'package:flutter/material.dart';
import 'package:kasir_kuliner/widgets/custom_drawer.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: Colors.blue,
      ),
      drawer: const CustomDrawer(), // ← GANTI drawer bawaan dengan custom
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          
        ],
      ),
    );
  }
}
