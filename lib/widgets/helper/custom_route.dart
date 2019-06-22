import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if(settings.isInitialRoute){
      return child;
    }
    return FadeTransition(opacity: animation,child: child,);
  }
}
