import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:recap_shops/screen/manage_product_screen.dart';
import 'package:recap_shops/screen/order_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('My shop'),
            automaticallyImplyLeading:
                false, //this means that it wont have a back button ever
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.manage_accounts),
              title: Text('Manage Product'),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(ManageProduct.routeName))
        ],
      ),
    );
  }
}
