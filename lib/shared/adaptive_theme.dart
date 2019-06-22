import 'package:flutter/material.dart';

final ThemeData _androidTheme = ThemeData(
    primaryColor: Colors.deepOrange,
    accentColor: Colors.deepPurple,
    brightness: Brightness.light,
    buttonColor: Colors.deepPurple,
    fontFamily: 'Montserrat');
final ThemeData _iosTheme = ThemeData(
    primarySwatch: Colors.grey,
    accentColor: Colors.blue,
    brightness: Brightness.light,
    buttonColor: Colors.blue,
    fontFamily: 'Montserrat');
ThemeData getAdaptiveThemeData(context) {
  return Theme.of(context).platform == TargetPlatform.iOS
      ? _iosTheme
      : _androidTheme;
}
