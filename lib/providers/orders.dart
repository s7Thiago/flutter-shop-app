import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  final _baseUrl = 'https://flutter-cod3r-shop-68ee0.firebaseio.com/orders';
  List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      '$_baseUrl.json',
      body: json.encode(
        {
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.items.values
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList(),
        },
      ),
    );

    _items.insert(
      0,
      Order(
        id: Random().nextDouble().toString(),
        total: cart.totalAmount,
        date: DateTime.now(),
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }

  Future<void> loadOrders() async {
    List<Order> loadedItems = [];
    final response = await http.get('$_baseUrl.json');
    Map<String, dynamic> data = json.decode(response.body);

    if (data != null) {
      data.forEach(
        (orderId, orderData) {
          loadedItems.add(
            Order(
              id: orderId,
              total: orderData['total'],
              date: DateTime.parse(orderData['date']),
              products: (orderData['products'] as List<dynamic>).map(
                (item) {
                  return CartItem(
                    id: item['id'],
                    productId: item['productId'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  );
                },
              ).toList(),
            ),
          );
        },
      );
      notifyListeners();
    }

    print('DATA => $data');

    _items = loadedItems.reversed.toList();

    return Future.value();
  }
}
