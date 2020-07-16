import 'dart:async';
import 'dart:convert';

import 'package:Oneblock/EnterPin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:Oneblock/AppEngine.dart';
import 'package:Oneblock/assets.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_share/flutter_share.dart';


import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';


class ReceiveMoney extends StatefulWidget {

  String address;
  ReceiveMoney(this.address);
  @override
  _ReceiveMoneyState createState() {
    return _ReceiveMoneyState();
  }
}

class _ReceiveMoneyState extends State<ReceiveMoney> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String address = "";
  bool setup=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    address = widget.address;
//    loadItems();
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // emailController.dispose();
    // passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        body: page());
  }

  page() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        addSpace(40),
        Row(
          children: [
            Container(
                width: 50,
                height: 50,
                child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close))),
            Flexible(
              fit: FlexFit.tight,
              child: Container(),
            ),
            // Image.asset(banner, width: 50, height: 50),
            addSpaceWidth(20)
          ],
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          width: double.infinity,
          height: errorText.isEmpty ? 0 : 40,
          color: red0,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Center(
              child: Text(
            errorText,
            style: textStyle(true, 16, white),
          )),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: new SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
//                  addSpace(20),
//                  Text(
//                    "Receive",
//                    style: textStyle(false, 50, app_red),
//                  ),


                    addSpace(30),
                    Center(child:QrImage(
                      data: address,
                      version: QrVersions.auto,
                      size: 150,
                      embeddedImage: AssetImage(banner),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(40,40),
                      ),
                    ),),
                    Center(child: Text(
                      "Scan QR Code",
                      style: textStyle(false, 16, black),
                    ),),
                    addSpace(20),
                    Container(
                      height: 50,width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: black.withOpacity(.1),width: 1)
                      ),
                      child: Row(
                        children: [
                          addSpaceWidth(15),
                          Flexible(fit: FlexFit.tight,
                              child: Text(address,
                                style: textStyle(false,18,black.withOpacity(.5)),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                          addSpaceWidth(10),
                          Container(width: 40,height: 40,
                          child: FlatButton(onPressed: (){
                            Clipboard.setData(ClipboardData(text: address));
                            showError("Copied");
                          },
                              padding: EdgeInsets.all(0),
                              child: Icon(Icons.content_copy,size: 18,)),)
                        ],
                      ),
                    ),
                    addSpace(20),

                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.all(0),
                      child: FlatButton(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: app_red,
                          onPressed: () async{
//                          send();
                            Share.share(address, subject: "OneBlock Address");

                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Share Code",
                                style: textStyle(true, 20, white),
                              ),
                              addSpaceWidth(5),
                              Icon(Icons.share,color:white)
                            ],
                          )),
                    ),
                    addSpace(100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String errorText = "";
  showError(String text) {
    errorText = text;
    setState(() {});
    Future.delayed(Duration(seconds: 1), () {
      errorText = "";
      setState(() {});
    });
  }

}
