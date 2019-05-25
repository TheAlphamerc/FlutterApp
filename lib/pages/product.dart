import 'package:flutter/material.dart';
import 'dart:async';
class ProductPage extends StatelessWidget {
 final String text;
  final String imageUrl;
  ProductPage(this.text, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(text),
        ),
        body: Column(
          children: <Widget>[
            Image.asset(imageUrl),
            Container(
              padding: EdgeInsets.all(10),
              child: Text('Detail'),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text('Delete'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ),
          ],
        ),
      ),
      onWillPop: () {
        print('[Product Page] Back button pressed');
        Navigator.pop(context,false);
        return Future.value(false);
      },
    );
  }
}
