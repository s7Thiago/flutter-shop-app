import 'package:flutter/material.dart';
import './views/products_overview_screen.dart';
import 'utils/routes.dart';
import './views/product_datail_screen.dart';
import './providers/counter_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CounterProvider(
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
