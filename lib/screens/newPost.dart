import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../models/post.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewPostScreen extends StatefulWidget {
  File image;

  NewPostScreen({Key key, this.image}) : super(key: key);

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  LocationData locationData;
  final formKey = GlobalKey<FormState>();
  final post = Post();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    post.lat = locationData.latitude;
    post.long = locationData.longitude;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    File image = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Litter PICker'),
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              Form(
                  key: formKey,
                  child: Column(children: [
                    SizedBox(
                        width: 500,
                        height: 50,
                        child: Center(
                            child:
                                Text('Lat: ${post.lat}, Long: ${post.long}'))),
                    SizedBox(child: Image.file(image)),
                    Padding(
                        padding: EdgeInsets.all(5),
                        child: TextFormField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                                hintText: 'Number of pieces of litter',
                                alignLabelWithHint: true),
                            onSaved: (value) {
                              post.numItems = int.parse(value);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Number of pieces is required!';
                              } else {
                                return null;
                              }
                            })),
                    SizedBox(
                        width: 200,
                        height: 75,
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: RaisedButton(
                                child: Icon(Icons.cloud_upload, size: 50),
                                onPressed: () async {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                    uploadData(image);
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  }
                                })))
                  ]))
            ])));
  }

  void uploadData(File image) async {
    post.date = DateTime.now();
    post.imageURL = await getFileURL(image);

    FirebaseFirestore.instance.collection('posts').add({
      'date': post.date.toString(),
      'imageURL': post.imageURL,
      'lat': post.lat,
      'long': post.long,
      'numItems': post.numItems
    });
  }
}

Future<String> getFileURL(File image) async {
  String imageURL;
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref().child('${DateTime.now().toString()}');
  UploadTask uploadTask = ref.putFile(image);

  TaskSnapshot snapshot = await uploadTask;

  imageURL = await ref.getDownloadURL();

  return imageURL;
}
