import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_widget.dart';

import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.itemsCount,
        itemBuilder: (ctx, index) => OrderWidget(orders.items[index]),
      ),
    );
  }
}
