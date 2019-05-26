import 'package:flutter/material.dart';

class ProductListView extends StatelessWidget {
  final List<Map<String, dynamic>> product;

  ProductListView(this.product);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      elevation: 5,
      child: Column(
        children: <Widget>[
          Image.asset(product[index]['image']),
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    product[index]['title'],
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald'),
                  ),
                  SizedBox(width: 15),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        '\$ ${product[index]['price'].toString()}',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              )),
          Container(
              padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 6),
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.circular(4)),
              child: Text('Sqaue , San Fransisco')),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Detail',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed<bool>(
                      context, '/products/' + index.toString());
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
