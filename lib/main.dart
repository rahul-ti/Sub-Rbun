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
        scaffoldBackgroundColor: Colors.white,
        /* appBarTheme: AppBarTheme().copyWith(
          iconTheme: IconThemeData(color: Colors.black,size: 24.0),
          color: Colors.white,
          elevation: 0.0,
        ), */
        brightness: Brightness.light,
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
