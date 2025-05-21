import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/orders_provider.dart';
import 'cart_item_model.dart';

class CartScreen extends StatefulWidget {
  final List<CartItemModel> cartItems;
  final Function(CartItemModel) onIncrease;
  final Function(CartItemModel) onDecrease;
  final Function(CartItemModel) onRemove;
  final Function() onClear;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    required this.onClear,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _guestCountController = TextEditingController();
  final TextEditingController _tableNumberController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  String _orderType = 'Dine In';
  final List<String> _orderTypes = ['Dine In', 'Take Away', 'Delivery'];
  bool _isPaid = false;

  int get totalAmount {
    return widget.cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get discountedTotal {
    final discount = int.tryParse(_discountController.text) ?? 0;
    return totalAmount - discount;
  }

  void _saveOrder() {
    if (_customerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama customer harus diisi')),
      );
      return;
    }

    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider.addOrder(
      customerName: _customerNameController.text,
      guestCount: _guestCountController.text,
      orderType: _orderType,
      tableNumber: _tableNumberController.text,
      isPaid: _isPaid,
      finalTotal: discountedTotal,
      discount: int.tryParse(_discountController.text) ?? 0,
      items: widget.cartItems,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pesanan ${_customerNameController.text} disimpan'),
      ),
    );

    // Navigate to order list or clear as needed
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _guestCountController.dispose();
    _tableNumberController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: Colors.blue,
        actions: [
          if (widget.cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text('Yakin mau hapus semua?'),
                        content: const Text(
                          'Semua item di keranjang akan dihapus',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              setState(() {
                                widget.cartItems.clear();
                              });
                            },
                            child: const Text(
                              'Hapus',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                );
              },
            ),
        ],
      ),
      body:
          widget.cartItems.isEmpty
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Keranjang masih kosong',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  // Customer Input Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _customerNameController,
                          decoration: InputDecoration(
                            labelText: 'Nama Customer',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _guestCountController,
                                decoration: InputDecoration(
                                  labelText: 'Jumlah Tamu',
                                  prefixIcon: const Icon(Icons.people),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _tableNumberController,
                                decoration: InputDecoration(
                                  labelText: 'Nomor Meja',
                                  prefixIcon: const Icon(
                                    Icons.table_restaurant,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: _orderType,
                          decoration: InputDecoration(
                            labelText: 'Jenis Pesanan',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items:
                              _orderTypes
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              _orderType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _discountController,
                          decoration: InputDecoration(
                            labelText: 'Diskon (Rp)',
                            prefixIcon: const Icon(Icons.discount),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text('Status Pembayaran:'),
                            const SizedBox(width: 10),
                            Switch(
                              value: _isPaid,
                              onChanged: (value) {
                                setState(() {
                                  _isPaid = value;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                            Text(_isPaid ? 'Sudah Bayar' : 'Belum Bayar'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Cart Items List
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.cartItems.length,
                      itemBuilder: (ctx, index) {
                        final item = widget.cartItems[index];
                        return Dismissible(
                          key: ValueKey(item.id),
                          background: Container(color: Colors.red),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => widget.onRemove(item),
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(item.image),
                              ),
                              title: Text(item.name),
                              subtitle: Text(
                                'Rp ${item.price} x ${item.quantity}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Rp ${item.totalPrice}'),
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => widget.onDecrease(item),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () => widget.onIncrease(item),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Total and Buttons Section
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
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () => _saveOrder(),
                                  child: const Text(
                                    'SIMPAN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
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
                                  onPressed: () async {
                                    if (_customerNameController.text.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Nama customer harus diisi',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    _saveOrder();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Pesanan berhasil dibuat!',
                                        ),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                    widget.onClear();
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'CHECKOUT',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
