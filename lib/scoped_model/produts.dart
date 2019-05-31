import 'package:flutter_app/models/product.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsModel extends Model{
 List<Product> _products = [];
 int _slectedProductIndex;
 bool _showFavourite = false;

  List<Product> get products {
   return List.from(_products);
  } 
   List<Product> get displayedproducts {
     if(_showFavourite){
       return _products.where((x)=> x.isFavourite == true).toList();
     }
   return List.from(_products);
  } 
  int get slectedProductIndex {
    return _slectedProductIndex;
  }
  Product get selectedProduct{
    if(_slectedProductIndex == null){
      return null;
    }
    return products[_slectedProductIndex];
  }
  bool get displayFavouriteOnly{
    return _showFavourite;
  }
  void addProduct(Product product) {
      _products.add(product);
      _slectedProductIndex = null;
  }
  void updateProduct(Product product){
      _products[_slectedProductIndex] = product;
      _slectedProductIndex = null;
  }
  void deleteProduct() {
      _products.removeAt(_slectedProductIndex);
      _slectedProductIndex = null;
  }
  
  void selectProduct(int index){
    _slectedProductIndex = index;
  }
  void setSelectedProductIndex(int index){
    _slectedProductIndex = index;
  }
  void toggleProductFavouriteToggle(){
    final bool isCurrentlyFavourite = selectedProduct.isFavourite;
    final bool newFavouriteStatus = !isCurrentlyFavourite; 
    final Product updatedProduct = Product(description: selectedProduct.description, title: selectedProduct.title,image: selectedProduct.image,price: selectedProduct.price,isFavourite: newFavouriteStatus);
    _products[_slectedProductIndex] = updatedProduct;
    _slectedProductIndex = null;
    notifyListeners();
  }
  
  void toggleDisplayModel(){
    _showFavourite = !_showFavourite;
    notifyListeners();
  }
}