import 'package:flutter_app/models/product.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsModel extends Model{
 List<Product> _products = [];
 int _slectedProductIndex;
 List<Product> get products {
   return List.from(_products);
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
  int get slectedProductIndex {
    return _slectedProductIndex;
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
  Product get selectedProduct{
    if(_slectedProductIndex == null){
      return null;
    }
    return products[_slectedProductIndex];
  }
}