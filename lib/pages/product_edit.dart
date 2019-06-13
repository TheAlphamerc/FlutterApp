import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/scoped_model/main.dart';
import 'package:flutter_app/widgets/form_input/image.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductEditPage extends StatefulWidget {
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
    'image': null
  };
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget _buildTitle(Product product) {
    if (product == null && _titleTextController.text.trim() == '') {
      _titleTextController.text = '';
    } else if (product != null && _titleTextController.text.trim() == '') {
      _titleTextController.text = product.title;
    }
    return TextFormField(
      controller: _titleTextController,
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

  Widget _buildDescription(Product product) {
    if (product == null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else if (product != null &&
        _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = product.description;
    }
    return TextFormField(
      maxLines: 2,
      controller: _descriptionTextController,
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

  Widget _buildPrice(Product product) {
    return TextFormField(
      initialValue: product != null ? product.price.toString() : "",
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

  Widget _showAlert() {
    return AlertDialog(
      title: Text('Something went wrong'),
      content: Text('Please try after some time'),
      actions: <Widget>[
        FlatButton(
          child: Text('Okay'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Widget _buildRaisedButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget widget, MainModel model) {
      {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                textColor: Colors.white,
                child: Text('Save'),
                onPressed: () => _submitForm(
                    model.addProduct,
                    model.updateProduct,
                    model.setSelectedProductId,
                    model.slectedProductId));
      }
    });
  }

  void _setImage(File file) {
    _formData['image'] = file;
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [String selectedProductIndex]) {
    if (!_formKey.currentState.validate() ||
        (_formData['image'] == null && selectedProductIndex == null)) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == null) {
      print('[Debug] Form is ready in Add new form');
      addProduct(
        _titleTextController.text,
        _descriptionTextController.text,
        _formData['image'],
        _formData['price'],
      ).then((bool isOk) {
        if (!isOk) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return _showAlert();
              });
          return;
        }
        print('[Debug] Navigate to home page');
        Navigator.pushReplacementNamed(context, '/home').then((_) {
          print('[Debug] Set selected product to null');
          setSelectedProduct(null);
        });
      });
    } else {
      print('[Debug] Form is ready in Edit  form');
      updateProduct(_titleTextController.text, _descriptionTextController.text,
              _formData['image'], _formData['price'])
          .then((bool isOk) {
        if (!isOk) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return _showAlert();
              });
          return;
        }
        print('[Debug] Navigate to home page');
        Navigator.pushReplacementNamed(context, '/home').then((_) {
          print('[Debug] Set selected product to null');
          setSelectedProduct(null);
        });
      });
      ;
    }
  }

  Widget _pagecontent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 400 : deviceWidth * .95;
    final double devicePadding = deviceWidth - targetWidth;
    return GestureDetector(
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
                    _buildTitle(product),
                    _buildDescription(product),
                    _buildPrice(product),
                    _buildSwitchTile(),
                    SizedBox(
                      height: 30,
                    ),
                    ImageInput(_setImage, product),
                    _buildRaisedButton()
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget widget, MainModel model) {
      {
        final Widget pageContent = _pagecontent(context, model.selectedProduct);
        return (model.selectedProductIndex == -1)
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Item'),
                ),
                body: pageContent);
      }
    });
  }
}
