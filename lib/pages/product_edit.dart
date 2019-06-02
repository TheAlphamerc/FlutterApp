import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/scoped_model/main.dart';
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
    'image':
        'https://www.google.com/imgres?imgurl=https%3A%2F%2Fhips.hearstapps.com%2Fdigitalspyuk.cdnds.net%2F16%2F38%2F1474456727-batman-ben-affleck.jpg%3Fcrop%3D1.00xw%3A0.893xh%3B0%2C0%26resize%3D480%3A*&imgrefurl=https%3A%2F%2Fwww.digitalspy.com%2Fmovies%2Fa27683260%2Fthe-batman-robert-pattinson-new-trilogy%2F&docid=3EiMkLUSLDPI-M&tbnid=IjM-TLCNOhOX4M%3A&vet=10ahUKEwjG-tS_usriAhXREHIKHQJHAb8QMwh7KAowCg..i&w=480&h=241&bih=549&biw=1280&q=batman&ved=0ahUKEwjG-tS_usriAhXREHIKHQJHAb8QMwh7KAowCg&iact=mrc&uact=8',
  };
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget _buildTitle(Product product) {
    return TextFormField(
      initialValue: product != null ? product.title : "",
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
    return TextFormField(
      initialValue: product != null ? product.description : "",
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
                    model.setSelectedProductIndex,
                    model.slectedProductIndex));
      }
    });
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProduct]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProduct == null) {
      addProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((_){
         Navigator.pushReplacementNamed(context, '/home')
        .then((_) => setSelectedProduct(null));
      });
        
      
    } else {
      updateProduct(_formData['title'], _formData['description'],
          _formData['image'], _formData['price']).then((_){
         Navigator.pushReplacementNamed(context, '/home')
        .then((_) => setSelectedProduct(null));
      });;
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
        return (model.slectedProductIndex == null)
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Item'),
                ),
                body: pageContent,
              );
      }
    });
  }
}
