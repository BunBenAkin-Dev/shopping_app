import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:recap_shops/providers/orders.dart' show Orders;
import 'package:recap_shops/widget/app_drawer.dart';
import 'package:recap_shops/widget/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order_screen';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _ordersFuture = null;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchandsetOrder();
  }

  @override
  void initState() {
    // TODO: implement initState
    // _isLoading = true;
    _ordersFuture = _obtainOrdersFuture();
    // Provider.of<Orders>(context, listen: false).fetchandsetOrder().then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: _ordersFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return const Center(
                      child: Text('AN Error noticed pls fix up'));
                } else {
                  return Consumer<Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                      itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                      itemCount: orderData.orders.length,
                    ),
                  );
                }
              }
              // return Center(
              //   child: CircularProgressIndicator(),
              // );
            }));
  }
}
