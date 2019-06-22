import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/pages/auth.dart';
import 'package:flutter_app/pages/product.dart';
import 'package:flutter_app/pages/products.dart';
import 'package:flutter_app/pages/products_Admin.dart';
import 'package:flutter_app/scoped_model/main.dart';
import 'package:flutter_app/shared/adaptive_theme.dart';
import 'package:flutter_app/widgets/helper/custom_route.dart';
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
  bool _isAuthenticated = false;
  final _plateformChanel = MethodChannel('flutter-app.com/battery');
  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await _plateformChanel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery lavel is $result%';
    } catch (error) {
      print(error);
      batteryLevel = 'Failed to get battery level';
    }
    print(batteryLevel);
  }

  final MainModel _model = new MainModel();
  @override
  void initState() {
    _model.autoAuthenticated();
    _model.userSubject.listen((bool isAuthenticated) {
      _isAuthenticated = isAuthenticated;
      print(
          "[Debug] Main page initState. isAuthenticated = ${isAuthenticated}");
    });
    _getBatteryLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("[Debug] Build main page");
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
            title: "EasyList",
            theme: getAdaptiveThemeData(context),
            // home: AuthPage(),
            routes: {
              // '/': (BuildContext context) => ProductsPage(_products),
              '/': (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : ProductsPage(_model),

              '/admin': (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : ProductAdminPage(_model),
              // '/home': (BuildContext context) => ProductsPage(_model),
              '/login': (BuildContext context) => AuthPage(),
            },
            onGenerateRoute: (RouteSettings settings) {
              if (!_isAuthenticated) {
                return MaterialPageRoute(
                    builder: (BuildContext context) => AuthPage());
              }
              final List<String> pathElements = settings.name.split('/');
              if (pathElements[0] != '') {
                return null;
              }
              if (pathElements[1] == 'products') {
                final String productId = pathElements[2];
                Product product = _model.allProducts.firstWhere((x) {
                  return x.id == productId;
                });
                return CustomRoute<bool>(
                    builder: (BuildContext context) =>
                        !_isAuthenticated ? AuthPage() : ProductPage(product));
              }
            },
            onUnknownRoute: (RouteSettings settings) {
              return MaterialPageRoute<bool>(
                  builder: (BuildContext context) =>
                      !_isAuthenticated ? AuthPage() : ProductsPage(_model));
            }));
  }
}
