import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({Key key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File image;

  void getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Scaffold(
          appBar: AppBar(centerTitle: true, title: Text('Litter PICker')),
          body: Center(
              child: Semantics(
                  button: true,
                  enabled: true,
                  onTapHint: 'Select a photo',
                  child: RaisedButton(
                      child: Text('Select Photo'),
                      onPressed: () {
                        getImage();
                      }))));
    } else {
      return Scaffold(
          appBar: AppBar(centerTitle: true, title: Text('Litter PICker')),
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Image.file(image),
                SizedBox(height: 40),
                Semantics(
                    button: true,
                    enabled: true,
                    onTapHint: 'Post the entry',
                    child: RaisedButton(
                        child: Text('Post It!'),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('newPost', arguments: image);
                        }))
              ])));
    }
  }
}
