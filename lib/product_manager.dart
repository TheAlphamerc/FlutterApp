import 'package:flutter/material.dart';
import './products.dart';
import './product_control.dart';

class ProductManager extends StatefulWidget {
  final Map<String,String> startingProduct;
  ProductManager(this.startingProduct) {
    print("[Product manager widget] Constructor ");
  }

  @override
  State<StatefulWidget> createState() {
    print("[Create state ] Constructor ");
    return _productManagerState();
  }
}

class _productManagerState extends State<ProductManager> {
  List<Map<String,String>> _product = [];
  @override
  void initState() {
    print('Init Produt manager');
    _product.add(widget.startingProduct);
    super.initState();
  }

  @override
  void didUpdateWidget(ProductManager oldWidget) {
    print("[Did update Product manager widget] ");
    super.didUpdateWidget(oldWidget);
  }

  void _addProduct(Map<String,String> product) {
    setState(() {
      _product.add(product);
    });
  }
  void _deleteProduct(int index){
    setState(() {
      _product.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    print("[Build Product manager widget] Constructor ");
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          child: ProductControl(_addProduct),
        ),
        Expanded(child: Products(_product,deleteProduct:_deleteProduct))
      ],
    );
  }
}
