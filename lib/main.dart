import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/orders_provider.dart';
import 'pages/dashboard_page.dart';
import 'pages/list_order_page.dart';
import 'pages/list_menu_page.dart';
import 'pages/report_page.dart';
import 'pages/order_page.dart';
import 'pages/pengaturan_page.dart'; 
import 'pages/about_application_page.dart'; 
import 'pages/profile_account_page.dart'; 
import 'login.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        // Tambahkan provider lainnya jika ada
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cashier App',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/list-order': (context) => const ListOrderPage(),
        '/list-menu': (context) => const ListMenuPage(),
        '/report': (context) => const ReportPage(),
        '/order': (context) => const OrderPage(),
        '/pengaturan': (context) => const PengaturanPage(),
        '/tentang-aplikasi': (context) => const AboutApplicationPage(), 
        '/profil-akun': (context) => const ProfileAccountPage(), 
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
