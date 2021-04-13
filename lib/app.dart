import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import './screens/list.dart';
import './screens/entryDetail.dart';
import './screens/newPost.dart';
import './screens/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  final SharedPreferences preferences;

  App({Key key, this.preferences}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  Map<String, WidgetBuilder> routes() {
    return {
      '/': (context) => ListScreen(),
      'postDetail': (context) => EntryDetailScreen(),
      'newPost': (context) => NewPostScreen(),
      'camera': (context) => CameraScreen()
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        routes: routes(),
        navigatorObservers: <NavigatorObserver>[observer]);
  }
}
