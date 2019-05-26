import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/products/product_card.dart';

class ProductListView extends StatelessWidget {
  final List<Map<String, dynamic>> product;

  ProductListView(this.product);

  @override
  Widget build(BuildContext context) {
    return product.length > 0
        ? ListView.builder(
            itemBuilder: (BuildContext context,int index)=> ProductCard(product[index],index),
            itemCount: product.length,
          )
        : Center(child: Text('No Item Available'));
  }
}
