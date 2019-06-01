import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/scoped_model/connected_product.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with ConnectedProductsModel ,ProductsModel , UserModel{

  // login(String email,String password) {
  //   _authenticatedUser = User(id:'sdc',email:email,password:password);
  // }
}
