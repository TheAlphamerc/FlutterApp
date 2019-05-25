import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
//  List<String> _product = ['Food Tester', 'food Fater'];
  @override
  Widget build(BuildContext context) {
    return Container(
        child: MaterialApp(
            theme: ThemeData(
                primaryColor: Colors.deepOrange,
                accentColor: Colors.purple,
                brightness: Brightness.light),
            home: HomePage()));
  }
}
