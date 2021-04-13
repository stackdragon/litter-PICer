import 'package:flutter/material.dart';
import '../models/post.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

class EntryDetailScreen extends StatefulWidget {
  final Post post;

  EntryDetailScreen({Key key, this.post}) : super(key: key);

  @override
  _EntryDetailScreenState createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Post post = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Litter PICker'),
        ),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
                DateFormat.yMMMMEEEEd()
                    .format(DateTime.parse(post.date.toString())),
                style: Theme.of(context).textTheme.headline5),
          ),
          Flexible(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage, image: post.imageURL)),
          Flexible(
              child: Text('${post.numItems} items',
                  style: Theme.of(context).textTheme.headline6)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
                'Location: ${post.long.toString()}, ${post.lat.toString()}',
                style: Theme.of(context).textTheme.headline6),
          ),
        ]));
  }
}
