import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/product_edit.dart';

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> _products;
  final Function updateProduct;
  ProductListPage(this._products, this.updateProduct);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                  backgroundImage: AssetImage(_products[index]['image'])),
              title: Text(_products[index]['title']),
              subtitle: Text('\$ ${_products[index]['price'].toString()}'),
              trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ProductEditPage(
                        product: _products[index],
                        updateProduct: updateProduct,
                        productIndex: index,
                      );
                    }));
                  }),
            ),
            Divider()
          ],
        );
      },
    );
  }
}
