import 'package:flutter/material.dart';

import '../models/product.dart';
import '../providers/counter_provider.dart';

class ProductDetatilScreen extends StatefulWidget {
  @override
  _ProductDetatilScreenState createState() => _ProductDetatilScreenState();
}

class _ProductDetatilScreenState extends State<ProductDetatilScreen> {
  @override
  Widget build(BuildContext context) {
    CounterProvider counter = CounterProvider.of(context);

    final Product product =
        ModalRoute.of(context).settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                setState(() {
                  counter.state.inc();
                });
                print('Provider: ${counter.state.value}');
              },
              child: Icon(Icons.add),
            ),
            Text(counter.state.value.toString())
          ],
        ),
      ),
    );
  }
}
