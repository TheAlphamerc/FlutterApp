import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/pages/product_edit.dart';
import 'package:flutter_app/scoped_model/produts.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatelessWidget {
  Widget _iconButton(BuildContext context, Product product,
      Function updateProduct, int index,ProductsModel model) {
    return  IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            model.setSelectedProductIndex(index);
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
  Widget _circleAvatar(String image){
    return CircleAvatar(backgroundImage: AssetImage(image),);
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget widget, ProductsModel model) {
      final List<Product> _products = model.products;
      {
        return ListView.builder(
          itemCount: _products.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(_products[index].title),
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
                  switch (direction) {
                    case DismissDirection.endToStart:
                      {
                        model.setSelectedProductIndex(index);
                        model.deleteProduct();
                        break;
                      }
                    case DismissDirection.startToEnd:
                      {
                        model.setSelectedProductIndex(index);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ProductEditPage();
                        }));
                        //updateProduct(index);
                        break;
                      }
                    default:
                      break;
                  }
                },
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: _circleAvatar(_products[index].image),
                      title: Text(_products[index].title),
                      subtitle: Text('\$ ${_products[index].price.toString()}'),
                      trailing: _iconButton(context, _products[index],
                          model.updateProduct, index,model),
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
