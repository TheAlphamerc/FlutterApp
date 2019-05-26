import 'package:flutter/material.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Map<String, dynamic> product;
  final Function updateProduct;
  final int productIndex;
  const ProductEditPage({this.addProduct, this.updateProduct, this.product,this.productIndex});
  @override
  State<StatefulWidget> createState() {
    return ProductEditPageState();
  }
}

class ProductEditPageState extends State<ProductEditPage> {
  String titleValue = '';
  String descriptionValue = '';
  double priceValue;
  bool acceptTerms = true;
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget _buildTitle() {
    return TextFormField(
      initialValue: widget.product != null ? widget.product['title'] :"",
      decoration:
          InputDecoration(labelText: 'Product Tile', icon: Icon(Icons.face)),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return "Title is required and +5 character long";
        }
      },
      onSaved: (value) {
        _formData['title'] = value;
        titleValue = value;
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      initialValue: widget.product != null ? widget.product['description'] :"",
      maxLines: 2,
      decoration: InputDecoration(
          labelText: 'Product Description', icon: Icon(Icons.storage)),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return "Desription is required and +5 character long";
        }
      },
      onSaved: (value) {
        _formData['description'] = value;
        descriptionValue = value;
      },
    );
  }

  Widget _buildPrice() {
    return TextFormField(
      initialValue: widget.product != null ? widget.product['price'].toString() :"",
      decoration: InputDecoration(
          labelText: 'Product Price', icon: Icon(Icons.euro_symbol)),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return "Price is required and should be a no.";
        }
      },
      onSaved: (value) {
        _formData['price'] = double.parse(value);
        priceValue = double.parse(value);
      },
    );
  }

  Widget _buildSwitchTile() {
    return SwitchListTile(
      value: acceptTerms,
      onChanged: (value) {
        acceptTerms = value;
      },
      title: Text('Accept terms'),
    );
  }

  Widget _buildRaisedButton() {
    return RaisedButton(
      textColor: Colors.white,
      child: Text('Save'),
      onPressed: () {
        _submitForm();
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if(widget.product == null){
        widget.addProduct(_formData);
    }
    else{
      widget.updateProduct(widget.productIndex,_formData);
    }
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 400 : deviceWidth * .95;
    final double devicePadding = deviceWidth - targetWidth;
    final Widget pageContent = GestureDetector(
        onTap: () {
          print("Focus out");
          FocusScope.of(context).autofocus(FocusNode());
        },
        child: Container(
            padding: EdgeInsets.all(30),
            child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: devicePadding / 2),
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
                ))));

    return (widget.product == null)
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Item'),
            ),
            body: pageContent,
          );
  }
}
