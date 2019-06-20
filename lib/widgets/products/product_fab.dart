import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/scoped_model/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductFAB extends StatefulWidget {
  final Product product;
  ProductFAB(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductFABState();
  }
}

class _ProductFABState extends State<ProductFAB> {
  @override
  Widget build(BuildContext context) {
    final userEmail = widget.product.userEmail;
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget widget, MainModel model) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 70,
            width: 56,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'Contact',
              mini: true,
              onPressed: () async {
                final url = 'mailto:${userEmail}';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw ('Could not launch');
                }
              },
              child: Icon(
                Icons.mail,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Container(
            height: 70,
            width: 56,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'Favourite',
              mini: true,
              onPressed: () {
                model.toggleProductFavouriteToggle();
              },
              child: Icon(
                model.selectedProduct.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
          ),
          Container(
            height: 70,
            width: 56,
            child: FloatingActionButton(
              heroTag: 'Options',
              onPressed: () {},
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
      );
    });
  }
}
