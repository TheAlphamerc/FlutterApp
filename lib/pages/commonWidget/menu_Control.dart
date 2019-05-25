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
          title: Text('Manage Product'),
          onTap: () {
            Navigator.pushNamed(context, '/admin');
          },
        ),
        ListTile(
          title: Text('Home page'),
          onTap: () {
            Navigator.pushNamed(context, '/home');
          },
        )
      ],
    ));
  }
}
