import 'package:flutter/material.dart';
import 'package:flutter_app/pages/commonWidget/menu_Control.dart';
import '../product_manager.dart';

class ProductsPage extends StatelessWidget {
  final List<Map<String, String>> product;
  final Function addProduct;
  final Function deleteProduct;
  ProductsPage(this.product, this.addProduct, this.deleteProduct) {
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
              child: Icon(Icons.add),
              padding: EdgeInsets.all(15),
            ),
            onTap: () {},
          ))
        ],
      ),
      body: ProductManager(product, addProduct, deleteProduct),
    );
  }
}
