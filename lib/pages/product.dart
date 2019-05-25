import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  String text;
  String imageUrl;
  ProductPage(this.text, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: Text('Back'),
              onPressed: () => Navigator.pop(context,true),
            ),
          ),
        ],
      ),
    ));
  }
}
