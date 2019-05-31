import 'package:flutter/widgets.dart';

class Product{
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isFavourite;
  Product(
    {@required this.title,
    @required this.price,
    @required this.description,
    @required this.image,
    this.isFavourite = false});
}