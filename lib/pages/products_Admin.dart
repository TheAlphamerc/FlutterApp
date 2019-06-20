import 'package:flutter/material.dart';
import 'package:flutter_app/pages/product_edit.dart';
import 'package:flutter_app/pages/product_list.dart';
import 'package:flutter_app/scoped_model/main.dart';
import 'commonWidget/menu_Control.dart';

class ProductAdminPage extends StatelessWidget {
  final MainModel model;
  ProductAdminPage(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
          drawer: MenuControlView(context),
          appBar: AppBar(
            title: Text("EasyList"),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "Create Product",
                  icon: Icon(Icons.create),
                ),
                Tab(text: "View Product", icon: Icon(Icons.list)),
              ],
              indicatorColor: Colors.black,
            ),
          ),
          body: TabBarView(
            children: <Widget>[ProductEditPage(), ProductListPage(model)],
          )),
      length: 2,
    );
  }
}
