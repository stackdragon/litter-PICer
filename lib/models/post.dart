class Post {
  String imageURL;
  int numItems;
  DateTime date;
  double lat;
  double long;

  Post({this.imageURL, this.numItems, this.date, this.lat, this.long});

  Post.fromMap(Map map) {
    this.imageURL = map['imageURL'];
    this.date = map['date'];
    this.numItems = map['numItems'];
    this.lat = map['lat'];
    this.long = map['long'];
  }
}
