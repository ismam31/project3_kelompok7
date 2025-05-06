import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/list_order_page.dart';
import 'pages/list_menu_page.dart';
import 'pages/report_page.dart';
import 'pages/order_page.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
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
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
