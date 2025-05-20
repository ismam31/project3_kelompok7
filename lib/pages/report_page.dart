import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../layouts/bottom_navigation.dart';
import '../widgets/custom_drawer.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final formatCurrency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  int totalIncome = 0;
  int totalOutcome = 0;
  int totalProfit = 0;
  int totalSales = 0;

  // Simulasi data transaksi
  final List<Map<String, dynamic>> transactions = [
    {'date': '2025-05-20', 'total': 75000, 'isPaid': true},
    {'date': '2025-05-19', 'total': 50000, 'isPaid': true},
    {'date': '2025-05-18', 'total': 100000, 'isPaid': true},
  ];

  @override
  void initState() {
    super.initState();
    loadReportData();
  }

  void loadReportData() {
    // contoh dummy, bisa ganti dari API / Provider
    totalIncome = 200000;
    totalOutcome = 50000;
    totalProfit = totalIncome - totalOutcome;
    totalSales = transactions.length;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan'),
        backgroundColor: Colors.blue,
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryCard(
              'Total Pendapatan',
              formatCurrency.format(totalIncome),
              Icons.attach_money,
              Colors.green,
            ),
            _buildSummaryCard(
              'Total Pengeluaran',
              formatCurrency.format(totalOutcome),
              Icons.money_off,
              Colors.red,
            ),
            _buildSummaryCard(
              'Total Keuntungan',
              formatCurrency.format(totalProfit),
              Icons.trending_up,
              Colors.blue,
            ),
            _buildSummaryCard(
              'Total Penjualan',
              totalSales.toString(),
              Icons.shopping_cart,
              Colors.orange,
            ),
            const SizedBox(height: 20),
            const Text(
              'Riwayat Transaksi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final trx = transactions[index];
                return ListTile(
                  leading: Icon(Icons.receipt, color: Colors.blue),
                  title: Text('Transaksi ${index + 1}'),
                  subtitle: Text(trx['date']),
                  trailing: Text(
                    formatCurrency.format(trx['total']),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
