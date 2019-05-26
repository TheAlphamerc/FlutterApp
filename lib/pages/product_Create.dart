import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;
  const ProductCreatePage(this.addProduct);
  @override
  State<StatefulWidget> createState() {
    return ProductCreatePageState();
  }
}

class ProductCreatePageState extends State<ProductCreatePage> {
  String titleValue = '';
  String descriptionValue = '';
  double priceValue;
  bool acceptTerms = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30),
        child: ListView(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  labelText: 'Product Tile', icon: Icon(Icons.face)),
              onChanged: (String value) {
                setState(() {
                  titleValue = value;
                });
              },
            ),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                  labelText: 'Product Description', icon: Icon(Icons.storage)),
              onChanged: (String value) {
                setState(() {
                  descriptionValue = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Product Price', icon: Icon(Icons.euro_symbol)),
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                setState(() {
                  priceValue = double.parse(value);
                });
              },
            ),
            SwitchListTile(
              value: acceptTerms,
              onChanged: (value) {
                setState(() {
                  acceptTerms = value;
                });
              },
              title: Text('Accept terms'),
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              child: Text('Save'),
              onPressed: () {
                final Map<String, dynamic> product = {
                  "title": titleValue,
                  "description": descriptionValue,
                  "price": priceValue,
                  "image": "assets/food.jpg"
                };
                widget.addProduct(product);
                Navigator.pushNamed(context, '/');
              },
            )
          ],
        ));
  }
}
