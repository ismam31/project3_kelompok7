import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders_provider.dart';
import '../layouts/bottom_navigation.dart';
import '../widgets/custom_drawer.dart';

class ListOrderPage extends StatefulWidget {
  const ListOrderPage({super.key});
  @override
  State<ListOrderPage> createState() => _ListOrderPageState();
}

class _ListOrderPageState extends State<ListOrderPage> {
  List<BluetoothDevice> device = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  void _showPrintDialog(BuildContext context, String orderId) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final order = ordersProvider.orders.firstWhere(
      (order) => order.id == orderId,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Printer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<BluetoothDevice>(
                value: selectedDevice,
                hint: const Text('Pilih printer'),
                onChanged: (device) => setState(() => selectedDevice = device),
                items:
                    device
                        .map(
                          (device) => DropdownMenuItem(
                            value: device,
                            child: Text(device.name ?? 'Unknown Device'),
                          ),
                        )
                        .toList(),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (!(await printer.isConnected)!) {
                        printer.connect(selectedDevice!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Printer terhubung')),
                        );
                      }
                    },
                    child: const Text('Connect'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  printer.disconnect();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Printer terputus')),
                  );
                },
                child: const Text('Disconnect'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Cetak struk
                  printer.printNewLine();
                  printer.printCustom("RUMAH MAKAN SEAFOOD", 3, 1);
                  printer.printCustom(
                    "Patimban, Kec Pusakanagara, Kabupaten Subang",
                    2,
                    1,
                  );
                  printer.printCustom("--------------------------------", 1, 0);
                  printer.printNewLine();
                  printer.printLeftRight("Nama", order.customerName, 1);
                  printer.printLeftRight("Tipe", order.orderType, 1);
                  if (order.orderType == "Dine In") {
                    printer.printLeftRight(
                      "Meja",
                      order.tableNumber.toString(),
                      1,
                    );
                  }
                  printer.printLeftRight(
                    "Tamu",
                    order.guestCount.toString(),
                    1,
                  );
                  printer.printCustom("--------------------------------", 1, 0);
                  printer.printLeftRight("Total", "Rp ${order.finalTotal}", 1);
                  printer.printLeftRight(
                    "Status",
                    order.isPaid ? "LUNAS" : "BELUM BAYAR",
                    1,
                  );
                  printer.printNewLine();
                  printer.printCustom("Terima Kasih!", 2, 1);
                  printer.printNewLine();
                  printer.printNewLine();
                },
                child: const Text('Print'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevice();
  }

  void getDevice() async {
    device = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;
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
                        _getOrderTypeIcon(order.orderType),
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      order.customerName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Tipe: ${order.orderType}'),
                        if (order.orderType == 'Dine In')
                          Text('Meja: ${order.tableNumber}'),
                        Text('Tamu: ${order.guestCount}'),
                        Text('Tanggal: ${_formatDate(order.date)}'),
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
                                    order.isPaid
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                order.isPaid ? 'LUNAS' : 'BELUM BAYAR',
                                style: TextStyle(
                                  color:
                                      order.isPaid
                                          ? Colors.green
                                          : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Rp ${order.finalTotal}',
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
                        _showOrderActions(context, order.id, order.isPaid);
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

  void _showOrderActions(BuildContext context, String orderId, bool isPaid) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
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
                isPaid ? Icons.payment : Icons.paid,
                color: isPaid ? Colors.green : Colors.blue,
              ),
              title: Text(isPaid ? 'Sudah Dibayar' : 'Tandai Lunas'),
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
                _showPrintDialog(context, orderId);
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

extension on BlueThermalPrinter {
  printTicket(String orderId) {}
}
