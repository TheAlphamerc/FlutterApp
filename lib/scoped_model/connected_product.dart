import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/auth.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/user.dart';
import 'package:http_parser/http_parser.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mime/mime.dart';

class ConnectedProductsModel extends Model {
  bool _isLoading = false;
  List<Product> _products = [];
  String _selSelectedId;
  User _authenticatedUser;

  void cPrint(statement) {
    debugPrint('${DateTime.now()}[Debug] ${statement}');
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

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    _isLoading = true;
    notifyListeners();
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-flutter-app-32074.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    cPrint(file.filename);
    cPrint(file.contentType);
    cPrint("File Length ${file.length}");
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
      cPrint("Image path ${imageUploadRequest.fields['imagePath']}");
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';
    // cPrint(imageUploadRequest.headers['Authorization']);
    try {
      final stramedResponse = await imageUploadRequest.send();
      cPrint("Initiate Upload ${stramedResponse.statusCode}");
      final response = await http.Response.fromStream(stramedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        cPrint(
            '[Error] firebase image upload. response : ${json.decode(response.body)}');
        _isLoading = false;
        notifyListeners();
        return null;
      }
      final responseData = json.decode(response.body);
      cPrint("Response data ${responseData}");
      _isLoading = false;
      notifyListeners();
      return responseData;
    } catch (error) {
      cPrint("[Exception] ${error}");
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> addProduct(
      String title, String description, File image, double price) async {
    try {
      _isLoading = true;

      var uploadData = await uploadImage(image);
      if (uploadData == null) {
        cPrint('Image upload failed');
        _isLoading = false;
        return false;
      }

      notifyListeners();
      final Map<String, dynamic> productData = {
        'title': title,
        'description': description,
        'imagePath': uploadData['imagePath'],
        'imageUrl': uploadData['imageUrl'],
        'price': price,
        'email': _authenticatedUser.email,
        'userId': _authenticatedUser.id
      };
      final http.Response response = await http.post(
          'https://flutter-app-32074.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
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
          image: uploadData['imageUrl'],
          imagePath: uploadData['imagePath'],
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
      String title, String description, File image, double price) async {
    try {
      _isLoading = true;
      notifyListeners();
      String imageUrl = selectedProduct.image;
      String imagePath = selectedProduct.imagePath;
      if (image != null) {
        var uploadData = await uploadImage(image);
        if (uploadData == null) {
          cPrint('Image upload failed');
          _isLoading = false;
          return false;
        }
        imageUrl = uploadData['imageUrl'];
        imagePath = uploadData['imagePath'];
      }
      final Map<String, dynamic> productData = {
        'title': title,
        'description': description,
        'imagePath': imagePath,
        'imageUrl': imageUrl,
        'price': price,
        'email': selectedProduct.userEmail,
        'userId': selectedProduct.userId
      };
      final http.Response response = await http.put(
          'https://flutter-app-32074.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
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
          image: imageUrl,
          imagePath: imagePath,
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
        'https://flutter-app-32074.firebaseio.com/products/${deletedProductId}.json?auth=${_authenticatedUser.token}',
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

  Future<Null> fetchProducts({onlyForUser = false}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final http.Response response = await http.get(
          'https://flutter-app-32074.firebaseio.com/products.json?auth=${_authenticatedUser.token}');

      cPrint('Data fetched from api');
      if (response.statusCode != 200 && response.statusCode != 201) {
        cPrint(
            'Fetch api response error. Status code:${response.statusCode} response: ${response.body}');
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
            image: productData['imageUrl'],
            imagePath: productData['imagePath'],
            userEmail: productData['email'],
            userId: productData['userId'],
            isFavourite: productData['wishlistUsers'] == null
                ? false
                : (productData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(_authenticatedUser.id));
        fetchedProductList.add(product);
      });
      _products = fetchedProductList.where((Product x) {
        return x.userId == _authenticatedUser.id;
      }).toList();
      cPrint("Product count ${_products.length}");
      cPrint("fetchedProductList count ${_products.length}");
      _isLoading = false;
      notifyListeners();
      _selSelectedId = null;
    } catch (error) {
      cPrint('[Exception] in add product. ${error} ${_authenticatedUser.id}');
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleProductFavouriteToggle() async {
    final bool isCurrentlyFavourite = selectedProduct.isFavourite;
    final bool newFavouriteStatus = !isCurrentlyFavourite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        description: selectedProduct.description,
        title: selectedProduct.title,
        image: selectedProduct.image,
        imagePath: selectedProduct.imagePath,
        price: selectedProduct.price,
        isFavourite: newFavouriteStatus,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updatedProduct;
    http.Response response;
    if (newFavouriteStatus) {
      response = await http.put(
          'https://flutter-app-32074.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
      if (response.statusCode != 200 && response.statusCode != 201) {
        final Product updatedProduct = Product(
            id: selectedProduct.id,
            description: selectedProduct.description,
            title: selectedProduct.title,
            image: selectedProduct.image,
            imagePath: selectedProduct.imagePath,
            price: selectedProduct.price,
            isFavourite: !newFavouriteStatus,
            userEmail: selectedProduct.userEmail,
            userId: selectedProduct.userId);
        _products[selectedProductIndex] = updatedProduct;

        cPrint(
            'Fsvourite product add  api response error. Status code:${response.statusCode} response: ${response.body}');
        _isLoading = false;
        notifyListeners();
        return;
      } else {
        cPrint('User id ${_authenticatedUser.id}');
        cPrint(
            'Fsvourite product add  successfull. Status code:${response.statusCode} response: ${response.body}');
      }
    } else {
      response = await http.delete(
          'https://flutter-app-32074.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        final Product updatedProduct = Product(
            id: selectedProduct.id,
            description: selectedProduct.description,
            title: selectedProduct.title,
            image: selectedProduct.image,
            price: selectedProduct.price,
            isFavourite: !newFavouriteStatus,
            userEmail: selectedProduct.userEmail,
            userId: selectedProduct.userId);
        _products[selectedProductIndex] = updatedProduct;
        cPrint(
            'Fsvourite product remove updated api response error. Status code:${response.statusCode} response: ${response.body}');
        _isLoading = false;
        notifyListeners();
        return;
      } else {
        cPrint(
            'Fsvourite product remove  successfull. Status code:${response.statusCode} response: ${response.body}');
      }
    }

    notifyListeners();
  }

  void toggleDisplayModel() {
    _showFavourite = !_showFavourite;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();
  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  void autoAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String expirtTimeString = prefs.getString('expiryTime');
    final String token = prefs.getString('token');
    if (token != null) {
      DateTime now = DateTime.now();
      final parseExpiryTime = DateTime.parse(expirtTimeString);
      if (parseExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        cPrint("Session Expire");
        notifyListeners();
        return;
      }
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final tokenLifeSpan = parseExpiryTime.difference(now).inSeconds;
      setAuthTimeOut(tokenLifeSpan);
      _authenticatedUser = new User(email: userEmail, id: userId, token: token);
      cPrint("Auto login. UserId : ${userId}");
      _userSubject.add(true);
      notifyListeners();
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("userEmail");
    await prefs.remove("userId");
    print('Logout');
    _authTimer.cancel();
    _userSubject.add(false);
  }

  void setAuthTimeOut(int time) {
    cPrint("Time Remaining for auto logout ${time}");
    _authTimer = Timer(Duration(seconds: time), logout);
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode authMode = AuthMode.Login]) async {
    try {
      final Map<String, dynamic> _authData = {
        'email': email,
        'password': password,
        'returnSecureToken': true
      };
      _isLoading = true;
      notifyListeners();
      http.Response response;
      if (authMode == AuthMode.Login) {
        response = await http.post(
            'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyAjc3XJO1612qcK0XOfmB5DrWGA1fb_lh8',
            body: json.encode(_authData),
            headers: {'content-Type': 'appliation/json'});
      } else {
        response = await http.post(
            'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyAjc3XJO1612qcK0XOfmB5DrWGA1fb_lh8',
            body: json.encode(_authData),
            headers: {'content-Type': 'appliation/json'});
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      bool hasError = true;
      String message = 'Something went wrong';
      if (responseData.containsKey('idToken')) {
        hasError = false;
        message = 'Authentication succeeded';
        _authenticatedUser = User(
            id: responseData['localId'],
            email: email,
            token: responseData['idToken']);
        cPrint('UserId = ${_authenticatedUser.id}');
        setAuthTimeOut(int.parse(responseData['expiresIn']));
        _userSubject.add(true);
        final now = DateTime.now();
        final expiryTime =
            now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
        cPrint(message);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _authenticatedUser.token);
        await prefs.setString('userEmail', _authenticatedUser.email);
        await prefs.setString('userId', _authenticatedUser.id);
        await prefs.setString('expiryTime', expiryTime.toIso8601String());
        await autoAuthenticated();
      } else if (responseData.containsKey('error')) {
        if (responseData['error']['message'] == "EMAIL_NOT_FOUND") {
          message = 'Email not found';
          cPrint(message);
        } else if (responseData['error']['message'] == "INVALID_EMAIL") {
          message = 'Invalid email';
          cPrint(message);
        } else if (responseData['error']['message'] == "EMAIL_EXISTS") {
          message = 'This email is already exists';
          cPrint(message);
        } else if (responseData['error']['message'] == "INVALID_PASSWORD") {
          message = 'Invalid password';
          cPrint(message);
        } else {
          cPrint(responseData);
        }
      } else {
        cPrint(responseData);
      }
      _isLoading = false;
      notifyListeners();
      return {'success': !hasError, "message": message};
    } catch (error) {
      cPrint('[Exception] in signup. ${error}');
      _isLoading = false;
      notifyListeners();
      return {'success': false, "message": "Authentication failed!"};
    }
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
