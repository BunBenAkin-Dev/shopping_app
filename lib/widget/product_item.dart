import 'package:flutter/material.dart';
import 'package:recap_shops/screen/product_detail_screen.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import 'package:recap_shops/providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            product.imageUrl,
            //product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        leading: Consumer<Product>(
          builder: (ctx, product, _) => IconButton(
            icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border),
            color: Theme.of(context).accentColor,
            onPressed: () {
              product.toggleFavouriteStatus();
            },
            // color: Theme.of(context).accentColor,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.shopping_cart,
          ),
          onPressed: () {
            cart.addItem(product.id ?? '', product.price, product.title);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added Item to cart'),
                duration: Duration(microseconds: 10),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    cart.removeSingleItem(product.id ??
                        ''); // since our id is acting up we put ? in our id class in product file and in other refrence where we call out id ?? ''
                  },
                ),
              ),
            );
          },
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
