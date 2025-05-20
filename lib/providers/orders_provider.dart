// providers/orders_provider.dart
import 'package:flutter/material.dart';
import '../pages/cart/order_model.dart';
import '../pages/cart/cart_item_model.dart';


class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  void addOrder({
    required String customerName,
    required String guestCount,
    required String orderType,
    required String tableNumber,
    required bool isPaid,
    required int finalTotal,
    required int discount,
    required List<CartItemModel> items,
  }) {
    final newOrder = OrderModel(
      id: DateTime.now().toString(),
      customerName: customerName,
      guestCount: guestCount,
      orderType: orderType,
      tableNumber: tableNumber,
      date: DateTime.now(),
      isPaid: isPaid,
      finalTotal: finalTotal,
      discount: discount,
      items: items,
    );

    _orders.insert(0, newOrder);
    notifyListeners();
  }

  void deleteOrder(String id) {
    _orders.removeWhere((order) => order.id == id);
    notifyListeners();
  }

  void togglePaymentStatus(String id) {
    try {
      final index = _orders.indexWhere((order) => order.id == id);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          isPaid: !_orders[index].isPaid,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling payment status: $e');
    }
  }

  void printTicket(String orderId) {}
}
