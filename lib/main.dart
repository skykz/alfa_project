import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.grey, // navigation bar color
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,

    statusBarColor: Colors.white, // status bar color
  ));
  runApp(MyApp());
}
