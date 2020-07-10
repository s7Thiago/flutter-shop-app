import 'package:flutter/material.dart';
import './views/products_overview_screen.dart';
import 'utils/routes.dart';
import './views/product_datail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
