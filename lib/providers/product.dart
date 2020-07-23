import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/exceptions/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final url =
        'https://flutter-cod3r-shop-68ee0.firebaseio.com/products/$id.json';

    _toggleFavorite();

    try {
      var response = await http.patch(
        url,
        body: json.encode(
          {'isFavorite': isFavorite},
        ),
      );

      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } on HttpException catch (error) {
      _toggleFavorite();
    }
  }
}
