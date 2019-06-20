import 'package:flutter/material.dart';
import 'package:flutter_app/scoped_model/main.dart';
import 'package:scoped_model/scoped_model.dart';

class MenuControlView extends StatelessWidget {
  BuildContext context;

  MenuControlView(this.context);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text('Choose'),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage Product'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/admin');
          },
        ),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Home page'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        Divider(),
        ScopedModelDescendant(
            builder: (BuildContext context, Widget widget, MainModel model) {
          return ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              model.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          );
        })
      ],
    ));
  }
}
