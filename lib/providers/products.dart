import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  final _baseUrl = 'https://flutter-cod3r-shop-68ee0.firebaseio.com/products';

  List<Product> _items = [];

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  int get itemsCount => _items.length;

  Future<void> loadProducts() async {
    final response = await http.get('$_baseUrl.json');

    Map<String, dynamic> data = json.decode(response.body);

    _items.clear();

    if (data != null)
      data.forEach(
        (productId, productData) {
          _items.add(
            Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              price: productData['price'],
              imageUrl: productData['imageUrl'],
              isFavorite: productData['isFavorite'],
            ),
          );
        },
      );
    notifyListeners();

    return Future.value();
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      '$_baseUrl.json',
      body: json.encode(
        {
          'id': product.id,
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        },
      ),
    );

    _items.add(
      Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners(); //notifies all the children interested in the products list (_items)
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }
    final index = _items.indexWhere((target) => product.id == target.id);

    if (index >= 0) {
      http.patch(
        '$_baseUrl/${product.id}.json',
        body: json.encode(
          {
            'id': product.id,
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((target) => target.id == id);

    if (index >= 0) {
      _items.removeWhere((target) => target.id == id);
      notifyListeners();
    }
  }
}
