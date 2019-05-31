import 'package:flutter/material.dart';
import 'package:flutter_app/pages/commonWidget/menu_Control.dart';
import 'package:flutter_app/scoped_model/produts.dart';
import 'package:flutter_app/widgets/products/Products.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuControlView(context),
      appBar: AppBar(
        title: Text("EasyList"),
        actions: <Widget>[
          ScopedModelDescendant(builder:
              (BuildContext context, Widget widget, ProductsModel model) {
            return IconButton(
              icon: Icon(model.displayFavouriteOnly
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                model.toggleDisplayModel();
              },
            );
          })
        ],
      ),
      body: ProductListView(),
    );
  }
}
