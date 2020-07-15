import 'dart:async';
import 'dart:ui';

import 'package:Oneblock/AppEngine.dart';
import 'package:Oneblock/Assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

StreamController<bool> progressController = StreamController<bool>.broadcast();
bool progressDialogShowing = false;

class progressDialog extends StatefulWidget {
  String message;
  bool cancelable;
  double countDown;
  progressDialog(
      {this.message = "", this.cancelable = false, this.countDown = 0});
  @override
  _progressDialogState createState() => _progressDialogState();
}

class _progressDialogState extends State<progressDialog> {
  String message;
  bool cancelable;
  double countDown;
  var sub;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    message = widget.message ?? "";
    cancelable = widget.cancelable ?? false;
    countDown = widget.countDown ?? 0;
    sub = progressController.stream.listen((_) {
      progressDialogShowing = false;
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    sub.cancel();
    super.dispose();
  }
/*
  void hideHandler() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (!progressDialogShowing) {
        Navigator.pop(context);
        return;
      }

//      setState(() {
//      });
      //message = currentProgressText;
      if (countDown > 0) {
        setState(() {
          countDown = countDown - 0.5;
        });
      }

      hideHandler();
    });
  }*/

  @override
  Widget build(BuildContext context) {
    //hideHandler();

    return WillPopScope(
      child: Stack(fit: StackFit.expand, children: <Widget>[
        GestureDetector(
          onTap: () {
            //if(cancelable)Navigator.pop(context);
          },
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: black.withOpacity(.2),
              )),
        ),
        page()
      ]),
      onWillPop: () {
        if (cancelable) Navigator.pop(context);
      },
    );
  }

  page() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          color: black.withOpacity(.8),
        ),
        Center(
            child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(color: white, shape: BoxShape.circle),
        )),
        Center(
          child: Opacity(
            opacity: 1,
            child: Image.asset(ic_plain, width: 25, height: 25),
          ),
        ),
        Center(
          child: Container(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              //value: 20,
              valueColor: AlwaysStoppedAnimation<Color>(white),
              strokeWidth: 2,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: new Container(),
              flex: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                countDown > 0
                    ? "$message (in ${countDown.toInt()} secs)"
                    : message,
                style: textStyle(false, 15, white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
