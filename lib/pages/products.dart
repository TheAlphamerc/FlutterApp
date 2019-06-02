import 'package:flutter/material.dart';
import 'package:flutter_app/pages/commonWidget/menu_Control.dart';
import 'package:flutter_app/scoped_model/main.dart';
import 'package:flutter_app/widgets/products/Products.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;
  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    print('[Debug] Home page');
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildProductList() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget widget, MainModel model) {
      Widget content = Center(
        child: Text("No data available"),
      );
      if (model.displayedproducts.length > 0 && !model.isLoading) {
        content = ProductListView();
      } else if (model.isLoading) {
        content = Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(onRefresh: model.fetchProducts, child: content);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuControlView(context),
      appBar: AppBar(
        title: Text("EasyList"),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget widget, MainModel model) {
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
      body: _buildProductList(),
    );
  }
}
