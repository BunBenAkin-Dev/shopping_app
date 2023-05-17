import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:recap_shops/providers/product_data_info.dart';
import 'package:recap_shops/screen/Edit_product_screen.dart';
import 'package:provider/provider.dart';

class ManageProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageurl;

  ManageProductItem(this.id, this.title, this.imageurl);

  @override
  Widget build(BuildContext context) {
    final Scaffold = ScaffoldMessenger.of(context);
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageurl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                  onPressed: () async {
                    try {
                      Provider.of<ProductDataInfo>(context, listen: false)
                          .deleteProduct(id);
                    } catch (error) {
                      Scaffold.showSnackBar(SnackBar(
                        content: Text('Deleting Failed'),
                        duration: Duration(seconds: 10),
                      ));
                    }
                    ;
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ))
            ],
          ),
        ));
  }
}
