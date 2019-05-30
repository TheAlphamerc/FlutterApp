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
  void setSelectedProductIndex(int index){
    _slectedProductIndex = index;
  }
  Product get selectedProduct{
    if(_slectedProductIndex == null){
      return null;
    }
    return products[_slectedProductIndex];
  }
}