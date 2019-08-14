import 'package:flutter/material.dart';
import 'package:kitty_paw/ui/cat_details/footer/details_footer.dart';
import 'package:kitty_paw/ui/cat_details/header/details_header.dart';
import 'package:kitty_paw/ui/cat_details/details_body.dart';
import 'package:meta/meta.dart';
import 'package:kitty_paw/models/cat.dart';

class CatDetailsPage extends StatefulWidget {
  final Cat cat;
  final Object avatarTag;

  CatDetailsPage(
    this.cat, {
    @required this.avatarTag,
    });

    @override
    _CatDetailsPageState createState() => new _CatDetailsPageState();

}

class _CatDetailsPageState extends State<CatDetailsPage>{
  @override
  Widget build(BuildContext context){

    var linearGradient = new BoxDecoration(
        gradient: new LinearGradient(
        begin:FractionalOffset.topCenter,
        end:FractionalOffset.bottomCenter,
        colors:[
          Colors.white,
          Colors.pink[100],
        ],
        ),
    );


    return new Scaffold(
      body: new SingleChildScrollView(
      child: new Container(
        decoration: linearGradient,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new CatDetailHeader(
              widget.cat,
              avatarTag:widget.avatarTag,
            ),
            new Padding(
            padding:const EdgeInsets.all(24.0),
            child: new CatDetailBody(widget.cat)
            ),
            new CatShowcase(widget.cat),
          ],
        ),
      )
      
      )
    );
  }
}
