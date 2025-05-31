import 'package:flutter/material.dart';
import 'package:kasir_kuliner/pages/cart/cart_item_model.dart';
import "package:kasir_kuliner/pages/success_transaction_page.dart";

class CheckoutScreen extends StatefulWidget {
  final List<CartItemModel> cartItems;
  final String customerName;
  final String guestCount;
  final String tableNumber;
  final String orderType;
  final int discount;
  final bool isPaid;
  final VoidCallback onClear;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.customerName,
    required this.guestCount,
    required this.tableNumber,
    required this.orderType,
    required this.discount,
    required this.isPaid,
    required this.onClear,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController bayarController = TextEditingController();

  int get totalAmount {
    return widget.cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity).toInt(),
    );
  }

  int get discountedTotal {
    final discount =
        _discountController.text.isEmpty
            ? 0
            : int.tryParse(_discountController.text) ?? 0;
    return totalAmount - discount;
  }

  @override
  void dispose() {
    _discountController.dispose();
    bayarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(
                  context,
                  icon: Icons.person,
                  title: 'Customer',
                  value: widget.customerName,
                ),
                if (widget.orderType == 'Dine In')
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          icon: Icons.table_restaurant,
                          title: 'Meja',
                          value: widget.tableNumber,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          icon: Icons.group,
                          title: 'Tamu',
                          value: widget.guestCount,
                        ),
                      ),
                    ],
                  ),
                _buildInfoCard(
                  context,
                  icon: Icons.receipt,
                  title: "Order Type",
                  value: widget.orderType,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Qty: ${item.quantity}, Rp ${item.price}'),
                  trailing: Text(
                    'Rp ${(item.price * item.quantity).toStringAsFixed(0)}',
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Diskon (Rp)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Harga:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp $discountedTotal',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => _buildPaymentDialog(context),
                      );
                    },
                    child: const Text(
                      'Pay',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDialog(BuildContext context) {
    final TextEditingController dialogDiscountController =
        TextEditingController(text: _discountController.text);
    String selectedPaymentMethod = 'Cash';

    return StatefulBuilder(
      builder: (context, setState) {
        int dialogDiscountedTotal =
            totalAmount -
            (dialogDiscountController.text.isEmpty
                ? 0
                : int.tryParse(dialogDiscountController.text) ?? 0);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Pembayaran'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer: ${widget.customerName}'),
                const SizedBox(height: 10),
                Text('Total: Rp $totalAmount'),
                const SizedBox(height: 10),
                TextField(
                  controller: dialogDiscountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Diskon (Rp)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedPaymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Metode Pembayaran',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['Cash', 'Dana', 'Ovo', 'BRI']
                          .map(
                            (method) => DropdownMenuItem(
                              value: method,
                              child: Text(method),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedPaymentMethod = value);
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bayarController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Bayar (Rp)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total Bayar: Rp $dialogDiscountedTotal',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final bayar = int.tryParse(bayarController.text) ?? 0;
                final kembalian = bayar - dialogDiscountedTotal;

                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            SuccessTransactionPage(kembalian: kembalian),
                  ),
                );

                widget.onClear();
              },
              child: const Text('Pay'),
            ),
          ],
        );
      },
    );
  }
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
