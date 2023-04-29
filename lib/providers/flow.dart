import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recap_shops/providers/cart.dart';

class flowItem with ChangeNotifier {
  final String id;
  final String title;
  final int quantity;
  final double amount;
  flowItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.amount});
}

// class flow with ChangeNotifier {
//   Map<String, flowItem> _items = {};
//   Map<String, flowItem> get items {
//     return {..._items};
//   }
// }
//ta
class flow with ChangeNotifier {
  Map<String, flowItem> _items = {};
  Map<String, flowItem> get items {
    return {..._items};
  }

  // void add(String ProductId, String title, double amount) {
  //   if (_items.containsKey(ProductId)) {
  //     _items.update(
  //       ProductId,
  //       (existingflowItem) => flowItem(
  //         id: existingflowItem.id,
  //         title: existingflowItem.title,
  //         quantity: existingflowItem.quantity + 1,
  //         amount: existingflowItem.amount,
  //       ),
  //     );
  //   } else {
  //     _items.putIfAbsent(
  //         ProductId,
  //         () => flowItem(
  //               id: DateTime.now().toString(),
  //               title: title,
  //               quantity: 1,
  //               amount: amount,
  //             )); // this adds a new item to our map of cart item
  //   }
  // }

  void add(
    String productId,
    String title,
    double amount,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingflowItem) => flowItem(
                id: existingflowItem.id,
                title: existingflowItem.title,
                quantity: existingflowItem
                    .quantity, // + 1, once you click cart you add +1 to quantity
                amount: existingflowItem.amount,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => flowItem(
                id: DateTime.now().toString(),
                title: title,
                quantity: 1,
                amount: amount,
              ));
    }
  }
}
