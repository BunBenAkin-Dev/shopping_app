import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recap_shops/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId; //take note the product id is a key not avalue
  final double price;
  final int quantity;
  final String title;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        //we use confirm dismiss to start up a show dialog
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure'),
                  content: Text('Do you want to remove $title from the cart '),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Yes')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('NO'))
                  ],
                ));
      },

      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4, //let align with the card margin when doing dismissible
        ),
      ),

      ///
      ///
      ///
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
