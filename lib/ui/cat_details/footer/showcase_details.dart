import 'package:flutter/material.dart';
import 'package:kitty_paw/models/cat.dart';

class DetailsShowcase extends StatelessWidget {

  final Cat cat;

  DetailsShowcase(this.cat);

  @override
  Widget build(BuildContext context){
    var textTheme = Theme.of(context).textTheme;
    return new Center(
      child: new Text(
        cat.description,
        textAlign: TextAlign.center,
        style:textTheme.subhead.copyWith(color: Colors.black)

      )
    );
  }
}