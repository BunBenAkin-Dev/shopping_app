import 'package:flutter/material.dart';
import 'package:recap_shops/providers/cart.dart';

class OrderItem with ChangeNotifier {
  final String Id;
  final double amount; //this is for total amount
  final List<CartItem> product;
  final DateTime dateTime;

  OrderItem({
    required this.Id,
    required this.amount,
    required this.product,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addorder(List<CartItem> cartProducts, double total) {
    _orders.insert(
        0,
        OrderItem(
          Id: DateTime.now().toString(),
          amount: total,
          product: cartProducts,
          dateTime: DateTime.now(),
        ));
    notifyListeners();
  }
}
