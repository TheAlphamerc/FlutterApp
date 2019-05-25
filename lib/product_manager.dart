import 'package:flutter/material.dart';
import './product_control.dart';
import 'Products.dart';

class ProductManager extends StatelessWidget {
  final List<Map<String, String>> product;
  final Function addProduct;
  final Function deleteProduct;
  ProductManager(this.product, this.addProduct, this.deleteProduct) {
    print("[Product manager widget] Constructor ");
  }
  @override
  Widget build(BuildContext context) {
    print("[Create state] Build Product manager widget");
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          child: ProductControl(addProduct),
        ),
        Expanded(child: ProductListView(product, deleteProduct: deleteProduct))
      ],
    );
  }
}
