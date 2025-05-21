import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: 130,
                    height: 130,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Kasir Kuliner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: const Text('Profil Akun'),
            tileColor: Colors.grey[200],
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.orange),
            title: const Text('Pengaturan'),
            onTap: () {
              Navigator.pushNamed(context, '/pengaturan');
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.green),
            title: const Text('Tentang Aplikasi'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
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
