import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recap_shops/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  // Future<void> fetchandsetOrders() async {
  //   final url = Uri.parse(
  //       'https://bunbenakin--test-default-rtdb.firebaseio.com/orders.json');
  //  // try {
  //   final List<OrderItem> loadedorders = [];
  //     final response = await http.get(url);
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedData == null){
  //       return;
  //     }
  //     extractedData.forEach((orderId, OrderData) {loadedorders.add(OrderItem(Id: orderId, amount: OrderData['amount'], product: (OrderData['product'] as List<dynamic>).map((item) => CartItem(id: item['id'], title: item['title'], quantity: item['quantity'], price: item['price'])).toList(), dateTime: DateTime.parse(OrderData['datetime'],),));});
  //  _orders = loadedorders.reversed.toList();
  //  //notifyListeners();
  //  // } catch (error) {
  //    // throw (error);
  //   }
  // }

  Future<void> fetchandsetOrder() async {
    final url = Uri.parse(
        'https://bunbenakin--test-default-rtdb.firebaseio.com/orders.json');
    final List<OrderItem> loadedOrders = [];
    final response = await http.get(url);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return; // it means that ifit is null the function does nothing this because we do not have a presaved order so if it fetches the database and sees nothing it should just return null;
    }
    extractedData.forEach((key, value) {
      loadedOrders.add(OrderItem(
        Id: key,
        amount: value['amount'],
        dateTime: DateTime.parse(value['datetime']),
        product: (value['product'] as List<dynamic>)
            .map((item) => CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price']))
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addorder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://bunbenakin--test-default-rtdb.firebaseio.com/orders.json');
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'datetime': timeStamp.toIso8601String(),
          'product': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList()
        }));
    //final orderId = json.decode(response.body)['name'];
    _orders.insert(
        0,
        OrderItem(
          Id: json.decode(response.body)['name'],
          amount: total,
          product: cartProducts,
          dateTime: DateTime.now(),
        ));
    notifyListeners();
  }
}
