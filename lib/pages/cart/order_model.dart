import 'cart_item_model.dart';

// models/order_model.dart
class OrderModel {
  final String id;
  final String customerName;
  final String guestCount;
  final String orderType;
  final String tableNumber;
  final DateTime date;
  final bool isPaid;
  final int finalTotal;
  final int discount;
  final List<CartItemModel> items;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.guestCount,
    required this.orderType,
    required this.tableNumber,
    required this.date,
    required this.isPaid,
    required this.finalTotal,
    required this.discount,
    required this.items,
  });

  factory OrderModel.empty() {
    return OrderModel(
      id: '',
      customerName: '',
      guestCount: '',
      orderType: '',
      tableNumber: '',
      date: DateTime.now(),
      isPaid: false,
      finalTotal: 0,
      discount: 0,
      items: [],
    );
  }

  OrderModel copyWith({bool? isPaid}) {
    return OrderModel(
      id: id,
      customerName: customerName,
      guestCount: guestCount,
      orderType: orderType,
      tableNumber: tableNumber,
      date: date,
      isPaid: isPaid ?? this.isPaid,
      finalTotal: finalTotal,
      discount: discount,
      items: items,
    );
  }
}
