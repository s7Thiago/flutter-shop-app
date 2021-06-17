import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './utils/routes.dart';
import './views/cart_screen.dart';
import './views/orders_screen.dart';
import './views/product_detail_screen.dart';
import './views/product_form_screen.dart';
import './views/products_screen.dart';
import 'views/auth_home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          // Valor padrão que será carregado caso o update não responda
          create: (_) => Products(),
          // Garante que ao atualizar este provider, os itens anteriores ao app sofrer um update em
          // busca de dados novos serão mantidos, ocorrendo apenas uma adição dos novos ao contexto
          // evitando assim uma desnecessária recarga integral dos dados na tela
          update: (context, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (context, auth, previousOrders) => Orders(
            auth.token,
            previousOrders.items,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'My Store',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.AUTH_HOME: (_) => AuthOrHomeScreen(),
          AppRoutes.PRODUCT_DETAIL: (_) => ProductDetailScreen(),
          AppRoutes.CART: (_) => CartScreen(),
          AppRoutes.ORDERS: (_) => OrdersScreen(),
          AppRoutes.PRODUCTS_MANAGER: (_) => ProductsScreen(),
          AppRoutes.FORM_SCREEN: (_) => ProductFormScreen(),
        },
      ),
    );
  }
}
