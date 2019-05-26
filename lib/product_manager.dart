import 'package:flutter/material.dart';
import 'Products.dart';

class ProductManager extends StatelessWidget {
  final List<Map<String, dynamic>> product;
  ProductManager(this.product) {
    print("[Product manager widget] Constructor ");
  }
  @override
  Widget build(BuildContext context) {
    print("[Create state] Build Product manager widget");
    return Column(
      children: <Widget>[
      
        Expanded(child: ProductListView(product))
      ],
    );
  }
}
