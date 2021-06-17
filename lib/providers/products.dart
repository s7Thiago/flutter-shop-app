import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/exceptions/http_exception.dart';

import 'product.dart';
import '../utils/constants.dart';

class Products with ChangeNotifier {
  final _baseUrl = '${Constants.BASE_API_URL}/products';
  List<Product> _items = [];
  String _token;

  Products(this._token, this._items);

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  int get itemsCount => _items.length;

  Future<void> loadProducts() async {
    final response = await http.get('$_baseUrl.json?auth=$_token');

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

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((target) => target.id == id);

    if (index >= 0) {
      final product = _items[index];

      _items.remove(product);
      notifyListeners();

      var response = await http.delete('$_baseUrl/${product.id}.json');

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();

        throw new HttpException('An error ocurred during product deletion');
      }
    }
  }
}
