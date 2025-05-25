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
      drawer: const CustomDrawer(),
      body: Center(
        child: Container(
          width:
              MediaQuery.of(context).size.width *
              0.8, // Lebar kontainer agar tetap di tengah
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Konten tetap sejajar di tengah
            children: [
              const Text(
                "Tentang Aplikasi",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Aplikasi Cashier App adalah solusi manajemen transaksi penjualan yang dirancang "
                "untuk memudahkan operasional bisnis. Dengan antarmuka yang intuitif dan fitur yang lengkap, "
                "aplikasi ini memungkinkan pengguna untuk mengelola penjualan, inventaris, dan laporan keuangan dengan lebih efisien.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify, // Rata kanan dan kiri
              ),
              const SizedBox(height: 20),
              const Text(
                "Fitur Utama",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start, // Pastikan item tetap sejajar dalam satu blok
                children: const [
                  Text(
                    "✅ Manajemen Akun: Kelola profil pengguna dan preferensi sistem dengan mudah.",
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    "✅ Pengaturan Sistem: Sesuaikan pengaturan aplikasi sesuai dengan kebutuhan bisnis.",
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    "✅ Pengelolaan Penjualan: Proses transaksi dengan cepat dan akurat.",
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    "✅ Keamanan Data: Perlindungan data pengguna untuk menjaga kerahasiaan dan keamanan informasi.",
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Aplikasi ini cocok untuk berbagai jenis usaha, mulai dari toko retail hingga usaha kuliner, "
                "membantu meningkatkan produktivitas dan akurasi dalam pencatatan penjualan.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify, // Rata kanan dan kiri
              ),
            ],
          ),
        ),
      ),
    );
  }
}
