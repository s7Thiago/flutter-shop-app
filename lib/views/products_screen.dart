import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/product_item.dart';

import '../providers/products.dart';
import '../utils/routes.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final productsList = productsProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage product'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.FORM_SCREEN);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsProvider.itemsCount,
          itemBuilder: (ctx, index) => Column(
            children: [
              ProductItem(productsList[index]),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
