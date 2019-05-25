import 'package:flutter/material.dart';

class ProductControl extends StatelessWidget{
  final Function addProduct;

  const ProductControl(this.addProduct);

  @override
  Widget build(BuildContext context) {
    
    return  RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text("Add New"),
            onPressed: () {
              addProduct({'title':'Chocklate','image':'assets/food.jpg'});
            },
          );
  }
  
}