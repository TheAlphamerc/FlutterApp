import 'package:flutter/material.dart';

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
            Navigator.pushNamed(context, '/admin');
          },
        ),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Home page'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        // ListTile(
        //   title: Text('Login'),
        //   onTap: () {
        //     Navigator.pushReplacementNamed(context, '/login');
        //   },
        // )
      ],
    ));
  }
}
