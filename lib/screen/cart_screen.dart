import 'package:recap_shops/widget/cart_item.dart';
import 'package:recap_shops/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:recap_shops/providers/cart.dart'
    show Cart; //it wont show cartitem class but just cart class

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    final cartprov = Provider.of<Cart>(context);
    final Ordprov = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Chip(
                    label: Text('\$${cartprov.totalamount.toStringAsFixed(2)}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  OrderButton(Ordprov: Ordprov, cartprov: cartprov)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartItem(
              cartprov.cartitemss.values
                  .toList()[i]
                  .id, // we add values to show us what is on that map and only work on the concretes value stored in the map
              cartprov.cartitemss.keys.toList()[i],
              cartprov.cartitemss.values
                  .toList()[i]
                  .price, //this enables that our valusr shows on cartscreen
              cartprov.cartitemss.values.toList()[i].quantity,
              cartprov.cartitemss.values.toList()[i].title,
            ),
            itemCount: cartprov.cartitemss.length,
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.Ordprov,
    required this.cartprov,
  });

  final Orders Ordprov;
  final Cart cartprov;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (widget.cartprov.totalamount <= 0 || _isLoading)
            ? null
            : (() async {
                setState(() {
                  _isLoading = true;
                });
                await widget.Ordprov.addorder(
                    widget.cartprov.cartitemss.values.toList(),
                    widget.cartprov.totalamount);
                widget.cartprov.clear();
                setState(() {
                  _isLoading = false;
                });
                // this clear the cart page after pressing order
              }),
        child:
            _isLoading ? const CircularProgressIndicator() : Text('Order Now'));
  }
}
