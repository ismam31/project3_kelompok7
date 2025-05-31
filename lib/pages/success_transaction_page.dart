import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:blue_thermal_printer/blue_thermal_printer.dart";

class SuccessTransactionPage extends StatefulWidget {
  final int kembalian;

  const SuccessTransactionPage({Key? key, required this.kembalian})
    : super(key: key);

  get order => null;

  @override
  State<SuccessTransactionPage> createState() => _SuccessTransactionPageState();
}

class _SuccessTransactionPageState extends State<SuccessTransactionPage> {
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
    printer.printCustom("WARUNG TIKUNGAN", 3, 1);
    printer.printCustom("Patimban, Kec Pusakanagara, Kabupaten Subang", 1, 1);
    printer.printCustom("--------------------------------", 1, 1);
    printer.printLeftRight("Nama", widget.order.customerName, 1);
    printer.printLeftRight("Tipe", widget.order.orderType, 1);
    if (widget.order.orderType == "Dine In") {
      printer.printLeftRight("Meja", widget.order.tableNumber.toString(), 1);
    }
    printer.printLeftRight("Tamu", widget.order.guestCount.toString(), 1);
    printer.printCustom("--------------------------------", 1, 1);
    for (var item in widget.order.items) {
      printer.printCustom(item.name, 1, 0);
      String qtyPrice = "x${item.quantity} Rp${item.price}";
      printer.printLeftRight(qtyPrice, "Rp${item.price * item.quantity}", 1);
    }
    printer.printCustom("--------------------------------", 1, 1);
    printer.printLeftRight(
      "Subtotal",
      "Rp ${widget.order.finalTotal + widget.order.discount}",
      1,
    );
    if (widget.order.discount > 0) {
      printer.printLeftRight("Diskon", "Rp ${widget.order.discount}", 1);
    }
    printer.printLeftRight("Total", "Rp ${widget.order.finalTotal}", 1);
    printer.printLeftRight(
      "Status",
      widget.order.isPaid ? "LUNAS" : "BELUM BAYAR",
      1,
    );
    printer.printNewLine();
    printer.printCustom("Terima Kasih!", 2, 1);
    printer.printNewLine();
    printer.printNewLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Berhasil'),
        backgroundColor: const Color(0xFF0492C2),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 16),
            const Text(
              'Good Job!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Transaksi berhasil!', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kembalian', style: TextStyle(fontSize: 18)),
                Text(
                  'Rp ${widget.kembalian.toString()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Tombol Transaksi Baru
            ElevatedButton(
              onPressed: () {
                // clear cart & redirect
                Get.offAllNamed('/order');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0492C2),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Transaksi Baru'),
            ),
            const SizedBox(height: 12),

            // Tombol Cetak Struk
            OutlinedButton.icon(
              onPressed: () async {
                // munculkan dialog pilih printer
                _printReceipt();
              },
              icon: const Icon(Icons.print),
              label: const Text('Cetak Struk'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Lihat Struk
            OutlinedButton(
              onPressed: () {
                // tampilkan preview struk
                Get.toNamed('/preview-struk');
              },
              child: const Text('Lihat Struk'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
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

  void launch(BuildContext context) {}
}
