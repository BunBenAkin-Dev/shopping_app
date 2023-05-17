import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:recap_shops/providers/product_data_info.dart';
import 'package:recap_shops/screen/Edit_product_screen.dart';
import 'package:recap_shops/widget/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:recap_shops/widget/manage_product_item.dart';

class ManageProduct extends StatelessWidget {
  const ManageProduct({super.key});
  static const routeName = '/Manage-Product';

  Future<void> _refreshproducts(BuildContext context) async {
    await Provider.of<ProductDataInfo>(context, listen: false)
        .fetchandsetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsdata35 = Provider.of<ProductDataInfo>(context);
    final ghju = productsdata35.items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Product'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshproducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: ghju.length,
            itemBuilder: (_, i) => Column(
              children: [
                ManageProductItem(
                  ghju[i].id ?? '',
                  ghju[i].title,
                  ghju[i].imageUrl,

                  //this shows that we are just picking some info from productsdataInfo
                ),
                Divider(color: Theme.of(context).primaryColor)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
