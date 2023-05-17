import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recap_shops/providers/cart.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //help us convert our data to json

class ProductDataInfo with ChangeNotifier {
  List<Product> _items = [
    //   Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description:
    //         'a college athlete who is withdrawn from university sporting events for a year to develop their skills and extend their period of playing eligibility by a further year at this level of competition. A redshirt freshman who had never started a college game and wasnt expecting to start in one this year',
    //     price: 29.99,
    //     imageUrl:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   ),
    //   Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   ),
    //   Product(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageUrl:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   ),
    //   Product(
    //     id: 'p4',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get ShowFavourites {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) =>
        prod.id ==
        id); //findbyID is a method named by me //((prod) reurn true if the id of the product iam looking for is equal to the ProductId take note product Id is in findbyID(ProductId) in product detail screen)
  }

  Future<void> fetchandsetProducts() async {
    final url = Uri.parse(
        'https://bunbenakin--test-default-rtdb.firebaseio.com/Products-Data-Info.json');
    try {
      final response = await http.get(url);
      final List<Product> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String,
          dynamic>; // this tells dart that the values are dynamic

      extractedData.forEach((ProdId, ProdData) {
        loadedProducts.add(Product(
            id: ProdId,
            title: ProdData['title'],
            description: ProdData['description'],
            price: ProdData['price'],
            isFavorite: ProdData['isFavorite'],
            imageUrl: ProdData['imageUrl']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://bunbenakin--test-default-rtdb.firebaseio.com/Products-Data-Info.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name']);
      _items.add(newProduct);
      //  _items.insert(0, newProduct);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    //.then((response) {

    // return Future.delayed(Duration(seconds: 2));
    // }).catchError((error) {
    //   print(error);
    //   throw error;
    // });
  }

  Future<void> updateProduct(String id, Product newproduct) async {
    final _proIndex = _items.indexWhere((prod) => prod.id == id);

    final url = Uri.parse(
        'https://bunbenakin--test-default-rtdb.firebaseio.com/Products-Data-Info/$id.json');
    await http.patch(url,
        body: json.encode({
          'title': newproduct.title,
          'description': newproduct.description,
          'price': newproduct.price,
          'imageUrl': newproduct.imageUrl,
        }));
    if (_proIndex >= 0) {
      _items[_proIndex] = newproduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Product findbyId2(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://bunbenakin--test-default-rtdb.firebaseio.com/Products-Data-Info/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete Product');
    }
    existingProduct = null;
    // _items.removeWhere((prod) => prod.id == id);
  }
}
