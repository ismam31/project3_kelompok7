import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:kasir_kuliner/pages/cart/order_model.dart';
import 'package:provider/provider.dart';
import 'package:kasir_kuliner/providers/orders_provider.dart';
import 'package:kasir_kuliner/pages/dashboard_page.dart';
import 'package:kasir_kuliner/pages/list_order_page.dart';
import 'package:kasir_kuliner/pages/list_menu_page.dart';
import 'package:kasir_kuliner/pages/report_page.dart';
import 'package:kasir_kuliner/pages/order_page.dart';
import 'package:kasir_kuliner/pages/pengaturan_page.dart';
import 'package:kasir_kuliner/pages/about_application_page.dart';
import 'package:kasir_kuliner/pages/profile_account_page.dart';
import 'package:kasir_kuliner/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/order': (context) => OrderPage(existingOrder: OrderModel.empty()),
        '/pengaturan': (context) => const PengaturanPage(),
        '/tentang-aplikasi': (context) => const AboutApplicationPage(),
        '/profil-akun': (context) => const ProfileAccountPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
