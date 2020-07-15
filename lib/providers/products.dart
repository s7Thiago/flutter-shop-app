import 'package:flutter/material.dart';

import 'product.dart';
import '../data/dummy_data.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  int get itemsCount => _items.length;

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners(); //notifyes all the children interested in the products list (_items)
  }
}
