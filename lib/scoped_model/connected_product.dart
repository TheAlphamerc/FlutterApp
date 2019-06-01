import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

class ConnectedProductsModel extends Model{
  List<Product> _products = [];
  int _selSelectedIndex;
    User _authenticatedUser; 
    void addProduct(String title , String description , String image, double price) {
    final Product product = new Product(
      description: description, 
      title: title,
      image: image,
      price: price,
      userEmail :_authenticatedUser.email,
      userId: _authenticatedUser.id);
      _products.add(product);
      
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

  int get slectedProductIndex {
    return _selSelectedIndex;
  }

  Product get selectedProduct {
    if (slectedProductIndex == null) {
      return null;
    }
    return _products[slectedProductIndex];
  }

  bool get displayFavouriteOnly {
    return _showFavourite;
  }

  void updateProduct(
    String title, String description, String image, double price) {
    final Product updatedProduct = new Product(
        description: description,
        title: title,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[slectedProductIndex] = updatedProduct;
    
  }

  void deleteProduct() {
    _products.removeAt(slectedProductIndex);
    
  }

  void selectProduct(int index) {
    _selSelectedIndex = index;
  }

  void setSelectedProductIndex(int index) {
    _selSelectedIndex = index;
  }

  void toggleProductFavouriteToggle() {
    final bool isCurrentlyFavourite = selectedProduct.isFavourite;
    final bool newFavouriteStatus = !isCurrentlyFavourite;
    final Product updatedProduct = Product(
        description: selectedProduct.description,
        title: selectedProduct.title,
        image: selectedProduct.image,
        price: selectedProduct.price,
        isFavourite: newFavouriteStatus,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[slectedProductIndex] = updatedProduct;
    
    notifyListeners();
  }

  void toggleDisplayModel() {
    _showFavourite = !_showFavourite;
    notifyListeners();
  }
}
class UserModel extends ConnectedProductsModel{
   void login(String email1,String password){
    _authenticatedUser = User(id:'sdc',email:email1,password:password);
   }
}