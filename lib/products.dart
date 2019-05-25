import 'package:flutter/material.dart';
import 'pages/product.dart';

class Products extends StatelessWidget {
  final List<Map<String, String>> product;
  Function deleteProduct;
  Products(this.product,{this.deleteProduct});

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product[index]['image']),
          Text(product[index]['title']),
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
                  Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ProductPage(
                              product[index]['title'],
                              product[index]['image'])
                              )
                              ).then( (bool value){
                                  if(value){
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
        : Center(child: Text('List Footer'));
  }
}
