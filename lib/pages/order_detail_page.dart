import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'cart/cart_item_model.dart';
import 'cart/order_model.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailPage({super.key, required this.order});

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
            _buildInfoCard(context, icon: Icons.person, title: 'Customer', value: order.customerName),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildInfoCard(context, icon: Icons.people, title: 'Tamu', value: order.guestCount)),
                const SizedBox(width: 10),
                Expanded(child: _buildInfoCard(context, icon: Icons.receipt, title: 'Tipe', value: order.orderType)),
              ],
            ),
            if (order.orderType == 'Dine In') ...[
              const SizedBox(height: 10),
              _buildInfoCard(context, icon: Icons.table_restaurant, title: 'Meja', value: order.tableNumber),
            ],
            const SizedBox(height: 20),
            const Text('Items Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Column(
              children: order.items.map((item) => _buildOrderItem(item, formatCurrency)).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Ringkasan Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildSummaryRow('Subtotal', formatCurrency.format(order.finalTotal + order.discount)),
            _buildSummaryRow('Diskon', '-${formatCurrency.format(order.discount)}'),
            const Divider(thickness: 2),
            _buildSummaryRow('TOTAL', formatCurrency.format(order.finalTotal), isTotal: true),
            const SizedBox(height: 20),
            _buildStatusChip(order.isPaid),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required IconData icon, required String title, required String value}) {
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
        child: Text(item.quantity.toString(), style: const TextStyle(color: Colors.blue)),
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
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 16 : 14)),
          Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 16 : 14, color: isTotal ? Colors.blue : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isPaid) {
    return Chip(
      label: Text(isPaid ? 'LUNAS' : 'BELUM BAYAR', style: const TextStyle(color: Colors.white)),
      backgroundColor: isPaid ? Colors.green : Colors.orange,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
