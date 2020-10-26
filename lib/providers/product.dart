import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/exceptions/http_exception.dart';
import 'package:shop_app/utils/constants.dart';

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
    final url = '${Constants.BASE_API_URL}/products/$id.json';

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
      // ignore: unused_catch_clause
    } on HttpException catch (error) {
      _toggleFavorite();
    }
  }
}
