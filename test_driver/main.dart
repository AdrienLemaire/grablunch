// This line imports the extension
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'package:grablunch/main.dart' show GrabLunchApp;

void main() {
  // This line enables the extension
  enableFlutterDriverExtension();

  runApp(new GrabLunchApp());
}
