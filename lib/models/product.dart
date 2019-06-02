import 'package:flutter/widgets.dart';

class Product{
  final String id; 
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isFavourite;
  final String userId;
  final String userEmail;
  Product(
    {
      @required this.id,
    @required this.title,
    @required this.price,
    @required this.description,
    @required this.image,
    @required this.userEmail,
    @required this.userId,
    this.isFavourite = false});
}