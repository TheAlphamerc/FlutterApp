import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/pages/product_edit.dart';
import 'package:flutter_app/scoped_model/connected_product.dart';
import 'package:flutter_app/scoped_model/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;
  ProductListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ProductListPageState();
  }
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    widget.model.fetchProducts(onlyForUser : true);
    super.initState();
  }

  Widget _iconButton(BuildContext context, Product product,
      Function updateProduct, int index, ProductsModel model) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          model.selectProduct(model.allProducts[index].id);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return ProductEditPage();
          }));
        });
  }

  Widget _icon(IconData icon) {
    return Container(
      alignment: Alignment(1, 0),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Icon(
        icon,
        color: Colors.white,
      ),
      color: Colors.red,
    );
  }

  Widget _circleAvatar(String image) {
    return CircleAvatar(
      backgroundImage: NetworkImage(image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget widget, MainModel model) {
      final List<Product> _products = model.allProducts;
      {
        return ListView.builder(
          itemCount: _products.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(model.allProducts[index].title),
                background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        _icon(Icons.edit),
                        _icon(Icons.delete)
                      ],
                    )),
                onDismissed: (DismissDirection direction) {
                  try {
                    switch (direction) {
                      case DismissDirection.endToStart:
                        {
                          model.selectProduct(model.allProducts[index].id);
                          model.deleteProduct();
                          break;
                        }
                      case DismissDirection.startToEnd:
                        {
                          model.selectProduct(model.allProducts[index].id);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ProductEditPage();
                          }));
                          //updateProduct(index);
                          break;
                        }
                      default:
                        break;
                    }
                  } catch (error) {
                    model.cPrint(
                        '[Exception] on productListPage >> Buid widget .${error}');
                  }
                },
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: _circleAvatar(_products[index].image),
                      title: Text(_products[index].title),
                      subtitle: Text('\$ ${_products[index].price.toString()}'),
                      trailing: _iconButton(context, _products[index],
                          model.updateProduct, index, model),
                    ),
                    Divider()
                  ],
                ));
          },
        );
      }
    });
  }
}
