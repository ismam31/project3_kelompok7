import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'pages/cart/order_model.dart';
import 'pages/cart/cart_item_model.dart';

Future<pw.Document> generateReceipt(OrderModel order) async {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Center(
              child: pw.Text(
                'RESTORAN KITA',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Center(
              child: pw.Text(
                'Jl. Contoh No. 123, Kota',
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Divider(thickness: 1),
            
            // Order Info
            pw.Text('No. Order: ${order.id.substring(0, 8)}'),
            pw.Text('Tanggal: ${DateFormat('dd/MM/yyyy HH:mm').format(order.date)}'),
            pw.Text('Customer: ${order.customerName}'),
            pw.Text('Tipe: ${order.orderType}'),
            if (order.orderType == 'Dine In') pw.Text('Meja: ${order.tableNumber}'),
            pw.Divider(thickness: 0.5),
            
            // Items List
            pw.Text('ITEM', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ...order.items.map((item) => pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('${item.name} (${item.quantity}x)'),
                pw.Text(formatCurrency.format(item.totalPrice)),
              ],
            )),
            pw.Divider(thickness: 0.5),
            
            // Summary
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Subtotal:'),
                pw.Text(formatCurrency.format(order.finalTotal + order.discount)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Diskon:'),
                pw.Text('-${formatCurrency.format(order.discount)}'),
              ],
            ),
            pw.Divider(thickness: 0.5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TOTAL:', 
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(formatCurrency.format(order.finalTotal),
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                order.isPaid 
                  ? 'LUNAS - TERIMA KASIH'
                  : 'BELUM BAYAR',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

  return pdf;
}