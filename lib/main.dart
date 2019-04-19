import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './pages/home.dart';

void main() {
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((_) {
    runApp(
      MyApp(),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme().copyWith(
          iconTheme: IconThemeData(color: Colors.black, size: 24.0),
          color: Colors.black,
          elevation: 0.0,
        ),
        brightness: Brightness.dark,
        buttonTheme: ButtonThemeData().copyWith(
          buttonColor: Colors.brown,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
