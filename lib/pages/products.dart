import 'package:flutter/material.dart';
import 'package:flutter_app/pages/commonWidget/menu_Control.dart';
import 'package:flutter_app/scoped_model/main.dart';
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
          ScopedModelDescendant<MainModel>(builder:
              (BuildContext context, Widget widget, MainModel model) {
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
