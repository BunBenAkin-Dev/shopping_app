import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:recap_shops/providers/auth.dart';
import 'package:recap_shops/providers/cart.dart';
import 'package:recap_shops/providers/orders.dart';
import 'package:recap_shops/screen/Edit_product_screen.dart';
import 'package:recap_shops/screen/auth_screen.dart';
import 'package:recap_shops/screen/cart_screen.dart';

import 'package:recap_shops/screen/manage_product_screen.dart';
import 'package:recap_shops/screen/order_screen.dart';
import 'package:recap_shops/screen/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'providers/product_data_info.dart';
import 'package:recap_shops/screen/product_overview_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// ({
//   status
// });

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = ThemeData();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, ProductDataInfo>(
            create: (ctx) => ProductDataInfo('', '', []),
            update: (ctx, auth, previousProducts) => ProductDataInfo(
                auth.token,
                auth.userId,
                previousProducts!.items == null ? [] : previousProducts.items),
            //create: (ctx) => ProductDataInfo(...),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', []),
            update: (ctx, auth, previousOrder) => Orders(
                auth.token,
                previousOrder!.orders == null
                    ? []
                    : previousOrder
                        .orders), //if previous.oorder is equal to null ten give us empty array[]; if it not equal to null give us previous orders
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'My Shop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
            ),
            //builder: EasyLoading.init(),
            home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              ManageProduct.routeName: (ctx) => ManageProduct(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
