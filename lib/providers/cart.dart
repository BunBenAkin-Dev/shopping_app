import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class CartItem with ChangeNotifier {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartitemss = {};

  Map<String, CartItem> get cartitemss {
    return {..._cartitemss};
  }

  int get itemcount {
    return _cartitemss.length;
  }

  double get totalamount {
    var total = 0.0;
    _cartitemss.forEach((key, value) {
      total += value.quantity * value.price;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    // we did not add quantity because quantity willbe added one at a time
    if (_cartitemss.containsKey(productId)) {
      _cartitemss.update(
        productId,
        (existingcartitem) => CartItem(
          id: existingcartitem.id,
          title: existingcartitem.title,
          quantity: existingcartitem.quantity + 1,
          price: existingcartitem.price,
        ),
      );
    } else {
      _cartitemss.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    //this is used to undo for snack bar
    if (!_cartitemss.containsKey(productId)) {
      return;
    }
    if (_cartitemss[productId]!.quantity > 1) {
      _cartitemss.update(
          productId,
          (existingcartitem) => CartItem(
              id: existingcartitem.id,
              title: existingcartitem.title,
              quantity: existingcartitem.quantity - 1,
              price: existingcartitem.price));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cartitemss.remove(productId);
    notifyListeners();
  }

  void clear() {
    _cartitemss = {};
    notifyListeners();
  }
}
