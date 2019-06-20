import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/scoped_model/main.dart';
import 'package:flutter_app/widgets/products/price_tag.dart';
import 'package:flutter_app/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';

import 'address_tag.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;
  ProductCard(this.product, this.productIndex);
  Widget _buildPriceRow() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleDefault(product.title),
            SizedBox(width: 15),
            PriceTag(product.price),
          ],
        ));
  }

  Widget _buildActionButton(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget widget, MainModel model) {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            color: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.pushNamed<bool>(
                  context, '/products/' + model.allProducts[productIndex].id);
            },
          ),
          IconButton(
            icon: Icon(model.allProducts[productIndex].isFavourite
                ? Icons.favorite
                : Icons.favorite_border),
            color: Colors.red,
            onPressed: () {
              model.selectProduct(model.allProducts[productIndex].id);
              model.toggleProductFavouriteToggle();
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(product.image),
            height: 300.0,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/food.jpg'),
          ),
          _buildPriceRow(),
          AddressTag("Union Square, San Fransisco"),
          Text(product.userEmail),
          _buildActionButton(context)
        ],
      ),
    );
  }
}
