import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker_modern/image_picker_modern.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;
  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400).then((File file) {
      setState(() {
        _imageFile = file;
      });
      Navigator.pop(context);
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Use Camera'),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = Theme.of(context).accentColor;
    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(color: buttonColor, width: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.camera_alt,
                color: buttonColor,
              ),
              Text(
                'Add Image',
                style: TextStyle(color: buttonColor),
              )
            ],
          ),
          onPressed: () {
            _openImagePicker(context);
          },
        ),
        SizedBox(
          height: 10,
        ),
        _imageFile == null
            ? Text("Please pick an image")
            : Image.file(
                _imageFile,
                fit: BoxFit.cover,
                height: 300,
                width: MediaQuery.of(context).size.width ,
                alignment: Alignment.topCenter,
              )
      ],
    );
  }
}
