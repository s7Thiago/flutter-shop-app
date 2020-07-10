import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './views/products_overview_screen.dart';
import 'views/product_detail_screen.dart';

import './utils/routes.dart';

import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Products(),
      child: MaterialApp(
        title: 'My Store',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.HOME: (_) => ProductsOverviewScreen(),
          AppRoutes.PRODUCT_DETAIL: (_) => ProductDetatilScreen(),
        },
      ),
    );
  }
}
