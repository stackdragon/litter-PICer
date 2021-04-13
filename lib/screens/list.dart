import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData &&
                    snapshot.data.docs != null &&
                    snapshot.data.docs.length > 0) {
                  int totalItems = 0;
                  snapshot.data.docs
                      .forEach((post) => totalItems += post['numItems']);
                  return Text('Litter PICker - $totalItems');
                } else {
                  return Text('Litter PICker');
                }
              })),

      //  title: Center(child: Text('Litter PICker'))),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('date', descending: true)
              .snapshots(),
          builder:
              (BuildContext conetxt, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.data.docs != null &&
                snapshot.data.docs.length > 0) {
              return Semantics(
                  link: true,
                  enabled: true,
                  onTapHint: 'Display the tile\'s detail view',
                  child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        var post = snapshot.data.docs[index];
                        return ListTile(
                            title: Text(DateFormat.yMMMMEEEEd()
                                .format(DateTime.parse(post['date']))
                                .toString()),
                            trailing: Text(post['numItems'].toString()),
                            onTap: () {
                              displayEntry(context, index, post);
                            });
                      }));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(builder: (context) {
        return Semantics(
            button: true,
            enabled: true,
            onTapHint: 'Select an Image',
            child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('camera');
                },
                child: Icon(Icons.camera_alt)));
      }),
    );
  }
}

void displayEntry(BuildContext context, int index, dynamic post) {
  Post selectedPost = new Post(
      date: DateTime.parse(post['date']),
      lat: post['lat'],
      long: post['long'],
      imageURL: post['imageURL'],
      numItems: post['numItems']);

  Navigator.of(context).pushNamed('postDetail', arguments: selectedPost);
}
