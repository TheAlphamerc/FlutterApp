import 'package:flutter/material.dart';

class ProductCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
         child: RaisedButton(
           child: Text("Create List"),
           onPressed: (){
             showModalBottomSheet(context: context ,builder: (BuildContext context){
               return Center(child: Text('Save'),);
             });
           },
      ),
    ));
  }
}
