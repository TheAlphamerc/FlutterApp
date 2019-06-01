import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/scoped_model/main.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  bool acceptTermsValue = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {'email': null, 'password': null};
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email', icon: Icon(Icons.email)),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return "Desription is required and +5 character long";
        }
      },
      onSaved: (value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', icon: Icon(Icons.enhanced_encryption)),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return "Password is should be alphanumeric";
        }
      },
      onSaved: (value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildSwitch() {
    return SwitchListTile(
      onChanged: (value) {
        setState(() {
          acceptTermsValue = value;
        });
      },
      title: Text('Accept Terms'),
      value: acceptTermsValue,
    );
  }

  Widget _buildSubmitButton(MainModel model) {
    return RaisedButton(
      textColor: Colors.white,
      child: Text("Login"),
      onPressed: () {
       _submitForm(model.login);
      },
    );
  }

  void _submitForm(Function login){
    if (!_formKey.currentState.validate()) {
      return;
      
    }
    _formKey.currentState.save();
    login(_formData['email'],_formData['password']);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 400 : deviceWidth * .9;
    final double devicePadding = deviceWidth - targetWidth;
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
                child: Form(
                    key: _formKey,
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: devicePadding / 2),
                      children: <Widget>[
                        _buildEmail(),
                        _buildPassword(),
                        _buildSwitch(),
                        SizedBox(
                          height: 50,
                        ),
                        ScopedModelDescendant(builder: (BuildContext context,Widget widget,MainModel model){
                          return  _buildSubmitButton(model);
                        })
                      ],
                    )
                  )
                )
              )
            );
  }
}
