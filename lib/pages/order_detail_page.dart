import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';
import 'cart/cart_item_model.dart';
import 'cart/order_model.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderModel order;
  const OrderDetailPage({super.key, required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<BluetoothDevice> device = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  void _printReceipt() async {
    BlueThermalPrinter printer = BlueThermalPrinter.instance;

    bool isConnected = await printer.isConnected ?? false;
    if (!isConnected) {
      showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            title: const Text("Pilih Printer"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<BluetoothDevice>(
                  value: selectedDevice,
                  hint: const Text('Pilih printer'),
                  onChanged:
                      (device) => setState(() => selectedDevice = device),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      child: const Text("Connect"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        printer.disconnect();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Printer terputus')),
                        );
                      },
                      child: const Text("Disconnect"),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
              ElevatedButton(
                onPressed: _printReceipt,
                child: const Text('Cetak'),
              ),
            ],
          );
        },
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Printer belum terkoneksi')));
      return;
    }

    printer.printNewLine();
    printer.printCustom("== STRUK PEMBELIAN ==", 3, 1);
    printer.printNewLine();
    printer.printCustom("Pembeli: ${widget.order.customerName}", 1, 0);
    printer.printCustom("Meja: ${widget.order.tableNumber}", 1, 0);
    printer.printCustom("Tamu: ${widget.order.guestCount}", 1, 0);
    printer.printCustom("--------------------------------", 1, 1);
    for (var item in widget.order.items) {
      printer.printCustom("x${item.quantity} ${item.name}", 1, 0);
    }
    printer.printCustom("--------------------------------", 1, 1);
    printer.printCustom("Terima kasih!", 1, 1);
    printer.printNewLine();
    printer.printNewLine();
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              context,
              icon: Icons.person,
              title: 'Customer',
              value: widget.order.customerName,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    context,
                    icon: Icons.people,
                    title: 'Tamu',
                    value: widget.order.guestCount,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInfoCard(
                    context,
                    icon: Icons.receipt,
                    title: 'Tipe',
                    value: widget.order.orderType,
                  ),
                ),
              ],
            ),
            if (widget.order.orderType == 'Dine In') ...[
              const SizedBox(height: 10),
              _buildInfoCard(
                context,
                icon: Icons.table_restaurant,
                title: 'Meja',
                value: widget.order.tableNumber,
              ),
            ],
            const SizedBox(height: 20),
            const Text(
              'Items Pesanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Column(
              children:
                  widget.order.items
                      .map((item) => _buildOrderItem(item, formatCurrency))
                      .toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ringkasan Pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildSummaryRow(
              'Subtotal',
              formatCurrency.format(
                widget.order.finalTotal + widget.order.discount,
              ),
            ),
            _buildSummaryRow(
              'Diskon',
              '-${formatCurrency.format(widget.order.discount)}',
            ),
            const Divider(thickness: 2),
            _buildSummaryRow(
              'TOTAL',
              formatCurrency.format(widget.order.finalTotal),
              isTotal: true,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusChip(widget.order.isPaid),
                ElevatedButton(
                  onPressed: () {
                    _printReceipt();
                  },
                  child: const Text('Cetak Struk'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getDevices();
  }

  void _getDevices() async {
    List<BluetoothDevice> devices = await printer.getBondedDevices();
    setState(() {
      device = devices;
    });
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(CartItemModel item, NumberFormat format) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.blue.withOpacity(0.1),
        child: Text(
          item.quantity.toString(),
          style: const TextStyle(color: Colors.blue),
        ),
      ),
      title: Text(item.name),
      trailing: Text(format.format(item.totalPrice)),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isPaid) {
    return Chip(
      label: Text(
        isPaid ? 'LUNAS' : 'BELUM BAYAR',
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isPaid ? Colors.green : Colors.orange,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
