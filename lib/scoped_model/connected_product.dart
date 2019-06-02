import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ConnectedProductsModel extends Model {
  bool _isLoading = false;
  List<Product> _products = [];
  String _selSelectedId;
  User _authenticatedUser;

  void cPrint(statement) {
    debugPrint('[Debug] ${statement}');
  }
}

class ProductsModel extends ConnectedProductsModel {
  bool _showFavourite = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedproducts {
    if (_showFavourite) {
      return _products.where((x) => x.isFavourite == true).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products.indexWhere((x) {
      return x.id == _selSelectedId;
    });
  }

  String get slectedProductId {
    return _selSelectedId;
  }

  Product get selectedProduct {
    if (_selSelectedId == null) {
      return null;
    }
    return _products.firstWhere((x) {
      return x.id == _selSelectedId;
    });
  }

  bool get displayFavouriteOnly {
    return _showFavourite;
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    try {
      _isLoading = true;
      notifyListeners();
      final Map<String, dynamic> productData = {
        'title': title,
        'description': description,
        'image':
            'http://tes77.com/wp-content/uploads/2017/10/dark-chocolate-bar-squares.jpg',
        'price': price,
        'email': _authenticatedUser.email,
        'userId': _authenticatedUser.id
      };
      final http.Response response = await http.post(
          'https://flutter-app-32074.firebaseio.com/products.json',
          body: jsonEncode(productData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        cPrint('[Error] add api response error');
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      cPrint('New product added');
      final Product product = new Product(
          id: responseData['name'],
          description: description,
          title: title,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(product);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      cPrint('[Exception] in add product. ${error}');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) async {
    try {
      _isLoading = true;
      notifyListeners();
      final Map<String, dynamic> productData = {
        'title': title,
        'description': description,
        'image':
            'http://tes77.com/wp-content/uploads/2017/10/dark-chocolate-bar-squares.jpg',
        'price': price,
        'email': selectedProduct.userEmail,
        'userId': selectedProduct.id
      };
      final http.Response response = await http.put(
          'https://flutter-app-32074.firebaseio.com/products/${selectedProduct.id}.json',
          body: jsonEncode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        cPrint('[Error] update api response error');
        _isLoading = false;
        notifyListeners();
        return false;
      }
      cPrint('Product updated');
      final Product updatedProduct = new Product(
          id: selectedProduct.id,
          description: description,
          title: title,
          image:
              "http://tes77.com/wp-content/uploads/2017/10/dark-chocolate-bar-squares.jpg",
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);

      _products[selectedProductIndex] = updatedProduct;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      cPrint('[Exception] in update product. ${error}');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void deleteProduct() async {
    try {
      _isLoading = true;
      final deletedProductId = selectedProduct.id;
      final int selectedProductIndex = _products.indexWhere((x) {
        return x.id == _selSelectedId;
      });
      _products.removeAt(selectedProductIndex);
      _selSelectedId = null;
      notifyListeners();
      final http.Response response = await http.delete(
        'https://flutter-app-32074.firebaseio.com/products/${deletedProductId}.json',
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        cPrint('[Error] Delete api response error');
        _isLoading = false;
        notifyListeners();
        return;
      }
      cPrint('Product deleted');
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return;
    }
  }

  void selectProduct(String productId) {
    _selSelectedId = productId;
    notifyListeners();
  }

  void setSelectedProductId(String productId) {
    if (productId == null) {
      cPrint("setSelectedProductId is set null");
    }
    _selSelectedId = productId;
    notifyListeners();
  }

  Future<Null> fetchProducts() async {
    try {
      _isLoading = true;
      notifyListeners();
      final http.Response response = await http
          .get('https://flutter-app-32074.firebaseio.com/products.json');

      cPrint('Data fetched from api');
      if (response.statusCode != 200 && response.statusCode != 201) {
        cPrint('Fetch api response error. Status code ${response.statusCode}');
        _isLoading = false;
        notifyListeners();
        return;
      }
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = new Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            image: productData['image'],
            userEmail: productData['email'],
            userId: productData['UserId']);
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selSelectedId = null;
    } catch (error) {
      cPrint('[Exception] in add product. ${error}');
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleProductFavouriteToggle() {
    final bool isCurrentlyFavourite = selectedProduct.isFavourite;
    final bool newFavouriteStatus = !isCurrentlyFavourite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        description: selectedProduct.description,
        title: selectedProduct.title,
        image: selectedProduct.image,
        price: selectedProduct.price,
        isFavourite: newFavouriteStatus,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updatedProduct;

    notifyListeners();
  }

  void toggleDisplayModel() {
    _showFavourite = !_showFavourite;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {
  void login(String email1, String password) {
    _authenticatedUser = User(id: 'sdc', email: email1, password: password);
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
