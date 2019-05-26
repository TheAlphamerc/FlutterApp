import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/pages/auth.dart';
import 'package:flutter_app/pages/product.dart';
import 'package:flutter_app/pages/products.dart';
import 'package:flutter_app/pages/products_Admin.dart';
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
  List<Map<String, dynamic>> _products = [];
  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      _products.add(product);
    });
  }
  void _updateProduct(int index,Map<String, dynamic> product){
     setState(() {
      _products[index] = product;
    });
  }
  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          brightness: Brightness.light,
          buttonColor: Colors.deepPurple,
          fontFamily:'Montserrat'),
          
      // home: AuthPage(),
      routes: {
        // '/': (BuildContext context) => ProductsPage(_products),
        '/': (BuildContext context) => AuthPage(),
        '/admin': (BuildContext context) => ProductAdminPage( _addProduct,_updateProduct,_deleteProduct,_products),
        '/home': (BuildContext context) => ProductsPage(_products,),
        '/login': (BuildContext context) => AuthPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'products') {
          final int index = int.parse(pathElements[2]);
          return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductPage(
                  _products[index]['title'], _products[index]['image']));
        }
      },
      onUnknownRoute: (RouteSettings settings){
        return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
            ProductsPage(_products));
        }
      
    ));
  }
}
