import 'package:flutter/material.dart';
import 'package:kasir_kuliner/pages/cart/cart_item_model.dart';

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
            : int.parse(_discountController.text);
    return totalAmount - discount;
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
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
                            icon: Icons.discount,
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
                    subtitle: Text('Qty: ${item.quantity}, \$${item.price}'),
                    trailing: Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Harga:'),
                      Text('Rp $totalAmount'),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Diskon:'),
                      Text(
                        'Rp ${_discountController.text.isEmpty ? 0 : int.parse(_discountController.text)}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Akhir:',
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
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Pay',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
