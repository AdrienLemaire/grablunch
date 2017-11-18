import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Debug packages
//import 'package:flutter/services.dart';
//import 'package:flutter/rendering.dart';
//import 'dart:developer';
import 'package:grablunch/app.dart' show AppScreen;


void main() {
  //debugPaintSizeEnabled=true;
  runApp(new GrabLunchApp());
}


class GrabLunchApp extends StatelessWidget {
  GrabLunchApp() {
    final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
    _firebaseMessaging.configure();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "GrabLunch",
      theme: defaultTargetPlatform == TargetPlatform.iOS
        ? kIOSTheme
        : kDefaultTheme,
      home: new AppScreen(),
    );
  }
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  accentColor: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.purple,
);
