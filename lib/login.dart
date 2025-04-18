import 'package:flutter/material.dart';
import 'package:kasir_kuliner/side_menu/pos_menu.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0077B6),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 150,
                    ),
                    const Text(
                      'Masuk',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Silakan login ke akun KasirKuliner',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 30),
                            const TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline),
                                labelText: 'Nama Pengguna',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline),
                                suffixIcon: Icon(Icons.visibility_off),
                                labelText: 'Kata Sandi',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text('Lupa kata sandi?'),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PosMenu()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'MASUK',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.g_mobiledata),
                              label: const Text('Sign in with Google'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Belum punya akun? '),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Mendaftar',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Dengan masuk aplikasi KasirKuliner berarti kamu telah membaca dan menerima',
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Ketentuan Layanan',
                                    style: TextStyle(color: Colors.blue, fontSize: 12),
                                  ),
                                ),
                                const Text(' dan ', style: TextStyle(fontSize: 12)),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Kebijakan Privasi',
                                    style: TextStyle(color: Colors.blue, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'Butuh bantuan?',
                                style: TextStyle(color: Colors.blue),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
