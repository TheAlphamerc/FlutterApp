import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/scoped_model/main.dart';
import 'package:flutter_app/widgets/products/product_card.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListView extends StatelessWidget {
  Widget _buildProductList(List<Product> product){
   return product.length > 0
        ? ListView.builder(
            itemBuilder: (BuildContext context,int index)=> ProductCard(product[index],index),
            itemCount: product.length,
          )
        : Center(child: Text('No Item Available'));
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget widget,MainModel model){
      return _buildProductList(model.displayedproducts);
       });
  } 
}
