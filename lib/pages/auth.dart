import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  bool acceptTermsValue = true;

  Widget _buildEmail() {
    return TextField(
      decoration: InputDecoration(labelText: 'Email', icon: Icon(Icons.email)),
      onChanged: (String value) {},
    );
  }

  Widget _buildPassword() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Password', icon: Icon(Icons.enhanced_encryption)),
      onChanged: (String value) {},
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

  Widget _buildSubmitButton() {
    return RaisedButton(
      textColor: Colors.white,
      child: Text("Login"),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/home');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 400 : deviceWidth * .9;
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child:Center(child: Container(
              width: targetWidth,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildEmail(),
                _buildPassword(),
                _buildSwitch(),
                SizedBox(
                  height: 50,
                ),
                _buildSubmitButton()
              ],
            ))))));
  }
}
