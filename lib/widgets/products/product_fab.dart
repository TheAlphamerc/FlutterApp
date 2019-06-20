import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/scoped_model/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
class ProductFAB extends StatefulWidget {
  final Product product;
  ProductFAB(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductFABState();
  }
}

class _ProductFABState extends State<ProductFAB> with TickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = widget.product.userEmail;
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget widget, MainModel model) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 70,
            width: 56,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).cardColor,
                heroTag: 'Contact',
                mini: true,
                onPressed: () async {
                  final url = 'mailto:${userEmail}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw ('Could not launch');
                  }
                },
                child: Icon(
                  Icons.mail,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Container(
            height: 70,
            width: 56,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0.0, .5, curve: Curves.easeOut)),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).cardColor,
                heroTag: 'Favourite',
                mini: true,
                onPressed: () {
                  model.toggleProductFavouriteToggle();
                },
                child: Icon(
                  model.selectedProduct.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Container(
            height: 70,
            width: 56,
            child: FloatingActionButton(
              heroTag: 'Options',
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
              child: AnimatedBuilder(
                animation: _controller,
                  builder: (BuildContext context, Widget widget) {
                return Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.rotationZ(_controller.value *.5 * math.pi),
                  child: Icon(_controller.isDismissed ? Icons.more_vert :Icons.close));
              }),
            ),
          ),
        ],
      );
    });
  }
}
