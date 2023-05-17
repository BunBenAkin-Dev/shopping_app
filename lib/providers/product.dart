import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  //final String? id;
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    //this.id,
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // void toggleFavouriteStatus() {
  //   isFavorite = !isFavorite;
  //   notifyListeners();
  // }

  void _setfavvalue(bool oldstatus) {
    isFavorite = oldstatus;
    notifyListeners();
  }

  void toggleFavouriteStatus() async {
    final oldstatus = isFavorite;
    try {
      isFavorite = !isFavorite;
      notifyListeners();
      final url = Uri.parse(
          'https://bunbenakin--test-default-rtdb.firebaseio.com/Products-Data-Info/$id.json');
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      if (response.statusCode >= 400) {
        _setfavvalue(oldstatus);

        // isFavorite = oldstatus;
        // notifyListeners();
      }
    } catch (error) {
      _setfavvalue(oldstatus);

      // isFavorite = oldstatus;
      // notifyListeners();
    }
  }
}


//https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg