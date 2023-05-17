import 'package:flutter/material.dart' hide Badge;
import 'package:recap_shops/providers/cart.dart';
import 'package:recap_shops/screen/cart_screen.dart';
import 'package:recap_shops/widget/app_drawer.dart';
import '../providers/product.dart';
import '../widget/product_item.dart';
import '../providers/cart.dart';
import '../widget/product_grid.dart';
import 'package:provider/provider.dart';
import 'package:recap_shops/screen/cart_screen.dart';
import 'package:recap_shops/widget/badge.dart';
import 'package:recap_shops/providers/product_data_info.dart';

enum FilterOptions {
  Favourites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyfavourite = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<ProductDataInfo>(context).fetchandsetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favourites) {
                    //this is the deciding factor the .all and .favourites
                    _showOnlyfavourite = true;
                  } else {
                    _showOnlyfavourite = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: ((_) => [
                    PopupMenuItem(
                        child: Text('Only Favourites'),
                        value: FilterOptions.Favourites),
                    PopupMenuItem(
                      child: Text('show all'),
                      value: FilterOptions.all,
                    ),
                  ])),
          Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(CartScreen.routeName);
                        },
                        icon: Icon(Icons.shopping_cart)),
                    value: cart.itemcount.toString(),
                  ))
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyfavourite),
    );
  }
}
