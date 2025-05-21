import 'package:flutter/material.dart';
import 'package:kasir_kuliner/widgets/custom_drawer.dart';

class AboutApplicationPage extends StatelessWidget {
  const AboutApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Aplikasi"),
        backgroundColor: Colors.blue,
      ),
      drawer: const CustomDrawer(), // ← GANTI drawer bawaan dengan custom
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil Akun'),
            onTap: () {
              // Navigasi atau aksi ke halaman profil
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            onTap: () {
              // Sudah di halaman ini, mungkin bisa disable atau beri indikasi
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Tentang Aplikasi'),
            onTap: () {
              // Navigasi ke halaman tentang aplikasi
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
            Navigator.pushNamed(context, '/dashboard');
            },
          ),
        ],
      ),
    );
  }
}
