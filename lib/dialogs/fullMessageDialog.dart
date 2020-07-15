import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Oneblock/AppEngine.dart';
import 'package:Oneblock/Assets.dart';

class fullMessageDialog extends StatelessWidget {
  String title;
  String message;
  String yesText;
  String noText;
  BuildContext context;
  bool cancellable;

  fullMessageDialog(
      this.title, this.message, this.yesText,
      {this.noText,
      bool this.cancellable = false,
      });

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return WillPopScope(
      onWillPop: () {
        if (cancellable) Navigator.pop(context);
      },
      child: Stack(fit: StackFit.expand, children: <Widget>[
        GestureDetector(
          onTap: () {
            if (cancellable) Navigator.pop(context);
          },
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: black.withOpacity(.7),
              )),
        ),
        page()
      ]),
    );
  }

  page(){
    return Column(
      children: <Widget>[
        Expanded(child: Center(child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                addSpace(30),
                Text(
                  title,
                  style: textStyle(true, 25, white),
                  textAlign: TextAlign.center,
                ),
                addSpace(5),
                Text("$message",style: textStyle(false, 25, white.withOpacity(.8)),textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),)),

        Container(
          height: 50,width: double.infinity,margin: EdgeInsets.all(15),
          child: FlatButton(
              materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),side: BorderSide(color: white,width: 1)),
              color: transparent,
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                yesText,
                style: textStyle(true, 18, white),
              )),
        ),
       /* noText == null
            ? new Container()
            : Container(
          width: double.infinity,
          child: FlatButton(
              materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
              *//*shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              color: blue3,*//*
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                noText,
                style: textStyle(false, 14, red0),
              )),
        ),*/
      ],
    );
  }

}
