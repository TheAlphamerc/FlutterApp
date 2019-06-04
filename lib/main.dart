import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/pages/auth.dart';
import 'package:flutter_app/pages/product.dart';
import 'package:flutter_app/pages/products.dart';
import 'package:flutter_app/pages/products_Admin.dart';
import 'package:flutter_app/scoped_model/main.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = new MainModel();
  @override
  void initState() {
    _model.autoAuthenticated();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
            theme: ThemeData(
                primaryColor: Colors.deepOrange,
                accentColor: Colors.deepPurple,
                brightness: Brightness.light,
                buttonColor: Colors.deepPurple,
                fontFamily: 'Montserrat'),

            // home: AuthPage(),
            routes: {
              // '/': (BuildContext context) => ProductsPage(_products),
              '/': (BuildContext context) => ScopedModelDescendant(builder:
                      (BuildContext context, Widget widget, MainModel model) {
                    return model.user == null
                        ? AuthPage()
                        : ProductsPage(_model);
                  }),
              '/admin': (BuildContext context) => ProductAdminPage(_model),
              '/home': (BuildContext context) => ProductsPage(_model),
              '/login': (BuildContext context) => AuthPage(),
            },
            onGenerateRoute: (RouteSettings settings) {
              final List<String> pathElements = settings.name.split('/');
              if (pathElements[0] != '') {
                return null;
              }
              if (pathElements[1] == 'products') {
                final String productId = pathElements[2];
                Product product = _model.allProducts.firstWhere((x) {
                  return x.id == productId;
                });
                return MaterialPageRoute<bool>(
                    builder: (BuildContext context) => ProductPage(product));
              }
            },
            onUnknownRoute: (RouteSettings settings) {
              return MaterialPageRoute<bool>(
                  builder: (BuildContext context) => ProductsPage(_model));
            }));
  }
}
