import 'package:kitty_paw/ui/cat_list.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(CatBoxApp());
}

class CatBoxApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var materialApp = new MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(
            primarySwatch: Colors.cyan,
            accentColor: Colors.pinkAccent,
            fontFamily: 'Ubuntu',
          ),
          home: new CatList(),
        );
        return materialApp;
  }
        
}