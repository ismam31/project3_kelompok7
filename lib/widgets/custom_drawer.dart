import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            onTap: () {
              // Aksi kalo mau
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            onTap: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Tentang Aplikasi'),
            onTap: () {
              // Aksi kalo mau
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/login'));
            },
          ),
        ],
      ),
    );
  }
}
