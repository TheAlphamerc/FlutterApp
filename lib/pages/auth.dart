import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Login"),
            ),
            body: Center(
              child: RaisedButton(
                child: Text("Login"),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            )));
  }
}
