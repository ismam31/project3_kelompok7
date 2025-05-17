import 'package:flutter/material.dart';
import '../layouts/bottom_navigation.dart';
import '../widgets/custom_drawer.dart';

class ListOrderPage extends StatelessWidget {
  const ListOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orders = [
      {
        'customerName': 'John Doe',
        'guestCount': '4',
        'orderType': 'Dine In',
        'tableNumber': '5',
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'isPaid': false,
        'finalTotal': 125000,
      },
      {
        'customerName': 'Jane Smith',
        'guestCount': '2',
        'orderType': 'Take Away',
        'tableNumber': '',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'isPaid': true,
        'finalTotal': 75000,
      },
      {
        'customerName': 'Bob Johnson',
        'guestCount': '6',
        'orderType': 'Delivery',
        'tableNumber': '',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'isPaid': true,
        'finalTotal': 185000,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pesanan"),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Daftar Pesanan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // Add filter functionality here
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getOrderTypeIcon(order['orderType']),
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      order['customerName'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Tipe: ${order['orderType']}'),
                        if (order['orderType'] == 'Dine In')
                          Text('Meja: ${order['tableNumber']}'),
                        Text('Tamu: ${order['guestCount']}'),
                        Text('Tanggal: ${_formatDate(order['date'])}'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    order['isPaid']
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                order['isPaid'] ? 'LUNAS' : 'BELUM BAYAR',
                                style: TextStyle(
                                  color:
                                      order['isPaid']
                                          ? Colors.green
                                          : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Rp ${order['finalTotal']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        _showOrderActions(context, orders, index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 1),
    );
  }

  IconData _getOrderTypeIcon(String orderType) {
    switch (orderType) {
      case 'Dine In':
        return Icons.restaurant;
      case 'Take Away':
        return Icons.takeout_dining;
      case 'Delivery':
        return Icons.delivery_dining;
      default:
        return Icons.receipt;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showOrderActions(
    BuildContext context,
    List<Map<String, dynamic>> orders,
    int index,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Detail Pesanan'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to order detail
              },
            ),
            ListTile(
              leading: Icon(
                orders[index]['isPaid'] ? Icons.payment : Icons.paid,
                color: orders[index]['isPaid'] ? Colors.green : Colors.blue,
              ),
              title: Text(
                orders[index]['isPaid'] ? 'Sudah Dibayar' : 'Tandai Lunas',
              ),
              onTap: () {
                Navigator.pop(context);
                // Toggle payment status
              },
            ),
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('Cetak Struk'),
              onTap: () {
                Navigator.pop(context);
                // Print receipt
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Hapus Pesanan',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                // Delete order
              },
            ),
          ],
        );
      },
    );
  }
}
