import 'package:flutter/material.dart';
import 'package:flutter_app/models/auth.dart';
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
  AuthMode _authMode = AuthMode.Login;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController =
      new TextEditingController();
  final Map<String, dynamic> _formData = {'email': null, 'password': null};
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email', icon: Icon(Icons.email)),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return "Email is required and +5 character long";
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
      controller: _passwordTextController,
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return "Password is should be alphanumeric";
        }
      },
      onSaved: (value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildConfirmPassword() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm password', icon: Icon(Icons.enhanced_encryption)),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return "Password do not match";
        }
      },
      onSaved: (value) {},
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
    return model.isLoading
        ? CircularProgressIndicator()
        : RaisedButton(
            textColor: Colors.white,
            child: Text("Login"),
            onPressed: () {
              _submitForm(model.authenticate);
            },
          );
  }

  void _submitForm(Function authenticate) async {
    try {
      if (!_formKey.currentState.validate()) {
        return;
      }
      _formKey.currentState.save();

      final Map<String, dynamic> response = await authenticate(
          _formData['email'], _formData['password'], _authMode);
      if (response['success']) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert'),
                content: Text(response['message']),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 400 : deviceWidth * .9;
    // final double devicePadding = deviceWidth - targetWidth;
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
                child: SingleChildScrollView(
                    child: Container(
                        width: targetWidth,
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                _buildEmail(),
                                _buildPassword(),
                                _authMode == AuthMode.SignUp
                                    ? _buildConfirmPassword()
                                    : Container(),
                                _buildSwitch(),
                                SizedBox(
                                  height: 50,
                                ),
                                FlatButton(
                                  child: Text(
                                      '${_authMode == AuthMode.Login ? 'SignUp' : 'SignIn'}'),
                                  onPressed: () {
                                    setState(() {
                                      _authMode = _authMode == AuthMode.Login
                                          ? AuthMode.SignUp
                                          : AuthMode.Login;
                                    });
                                  },
                                ),
                                ScopedModelDescendant(builder:
                                    (BuildContext context, Widget widget,
                                        MainModel model) {
                                  return _buildSubmitButton(model);
                                })
                              ],
                            )))))));
  }
}
