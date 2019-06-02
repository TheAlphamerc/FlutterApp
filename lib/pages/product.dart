import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/scoped_model/main.dart';
import 'dart:async';

import 'package:flutter_app/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductPage extends StatelessWidget {
  final int index;
  ProductPage(this.index);
  void _showDialague(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure"),
            content: Text("This action cannot be undone"),
            actions: <Widget>[
              FlatButton(
                child: Text('Discard'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Continue'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      print('[Product Page] Back button pressed');
      Navigator.pop(context, false);
      return Future.value(false);
    }, child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget widget, MainModel model) {
      final Product product = model.allProducts[index];
      return Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: Column(
          children: <Widget>[
            Image.network(product.image),
            Container(
              padding: EdgeInsets.all(10),
              child: TitleDefault(product.title),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text('Delete'),
                onPressed: () => _showDialague(context),
              ),
            ),
          ],
        ),
      );
    }));
  }
}
