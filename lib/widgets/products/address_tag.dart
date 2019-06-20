import 'package:flutter/material.dart';

class AddressTag extends StatelessWidget {
  final String address;

  const AddressTag( this.address) ;

  @override
  Widget build(BuildContext context) {
    return Container(
              padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 6),
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.circular(4)),
              child: Text(address));
  }
}
