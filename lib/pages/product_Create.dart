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
  Widget _buildTitle() {
    return TextField(
      decoration:
          InputDecoration(labelText: 'Product Tile', icon: Icon(Icons.face)),
      onChanged: (String value) {
        setState(() {
          titleValue = value;
        });
      },
    );
  }

  Widget _buildDescription() {
    return TextField(
      maxLines: 2,
      decoration: InputDecoration(
          labelText: 'Product Description', icon: Icon(Icons.storage)),
      onChanged: (String value) {
        setState(() {
          descriptionValue = value;
        });
      },
    );
  }

  Widget _buildPrice() {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Product Price', icon: Icon(Icons.euro_symbol)),
      keyboardType: TextInputType.number,
      onChanged: (String value) {
        setState(() {
          priceValue = double.parse(value);
        });
      },
    );
  }

  Widget _buildSwitchTile() {
    return SwitchListTile(
      value: acceptTerms,
      onChanged: (value) {
        setState(() {
          acceptTerms = value;
        });
      },
      title: Text('Accept terms'),
    );
  }

  Widget _buildRaisedButton() {
    return RaisedButton(
      
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
        Navigator.pushNamed(context, '/home');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 400 : deviceWidth * .95;
    final double devicePadding = deviceWidth - targetWidth;
    return Container(
        
        padding: EdgeInsets.all(30),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: devicePadding/2),
          children: <Widget>[
            _buildTitle(),
            _buildDescription(),
            _buildPrice(),
            _buildSwitchTile(),
            SizedBox(
              height: 30,
            ),
            _buildRaisedButton()
          ],
        ));
  }
}
