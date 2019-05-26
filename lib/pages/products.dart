import 'package:flutter/material.dart';
import 'package:flutter_app/pages/commonWidget/menu_Control.dart';
import 'package:flutter_app/widgets/products/Products.dart';

class ProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> product;
  ProductsPage(this.product) {
    print("[Product manager widget] Constructor ");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuControlView(context),
      appBar: AppBar(
        title: Text("EasyList"),
        actions: <Widget>[
          Center(
              child: GestureDetector(
            child: Container(
              child: Icon(Icons.favorite),
              padding: EdgeInsets.all(15),
            ),
            onTap: () {},
          ))
        ],
      ),
      body: ProductListView(product),
    );
  }
}
