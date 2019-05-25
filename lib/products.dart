import 'package:flutter/material.dart';
import 'pages/product.dart';

class ProductListView extends StatelessWidget {
  final List<Map<String, String>> product;
  final Function deleteProduct;
  ProductListView(this.product, {this.deleteProduct});

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product[index]['image']),
          Container(
              padding: EdgeInsets.all(10),
              child: Text(product[index]['title'])),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Column(
                  children: <Widget>[
                    Text('Detail'),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed<bool>(
                          context, '/products/' + index.toString())
                      .then((bool value) {
                    if (value) {
                      print(value);
                      deleteProduct(index);
                    }
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return product.length > 0
        ? ListView.builder(
            itemBuilder: _buildProductItem,
            itemCount: product.length,
          )
        : Center(child: Text('No Item Available'));
  }
}
