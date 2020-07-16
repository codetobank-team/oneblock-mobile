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


class Details extends StatefulWidget {

  Map item;
  Details(this.item);
  @override
  _DetailsState createState() {
    return _DetailsState();
  }
}

class _DetailsState extends State<Details> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map item;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    item = widget.item;
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
    /*
    * {status: completed, blockchainTimestamp: 1594880277637,
    * sender: 0x7fff8d4A4ec32BEbFf43B9316d4BE8369d805858,
    * recipient: 0x663Ff687C051f12516337f38004F11dBd08D5f93,
    * hash: 56ce6e75e3ed7a4fe569fa6b3661a9b80a856bd4b4d9f8b775265e9cdb7427b7,
    * amount: 400, createdAt: 2020-07-16T06:17:57.643Z,
    * updatedAt: 2020-07-16T06:17:57.643Z, id: 5f0ff115ae1752001d99ce8d, type: sent}*/

    bool incoming = item["type"]!="sent";
    String recipient = item["recipient"]??"";
    String sender = item["sender"]??"";
    String amount = formatAmount(item["amount"]);
    int time = item["blockchainTimestamp"];
    String hash = item["hash"]??"";
    var color = incoming ? blue0 : black.withOpacity(.5);
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

                  addSpace(20),
                  Text(
                    "Details",
                    style: textStyle(false, 50, app_red),
                  ),
                  addSpace(10),
                  Row(children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text("Time",style: textStyle(false, 16, black.withOpacity(.5)),),
                    ),
                    Icon(Icons.access_time,size: 14,),
                    addSpaceWidth(5),
                    Text(
                      getChatDate(time),
                      style: textStyle(false, 14, black.withOpacity(.5)),
                    )
                  ],),
                  addLine(.5,black.withOpacity(.1),0,10,0,10),
                  Row(children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text("Amount",style: textStyle(false, 16, black.withOpacity(.5)),),
                    ),
                    Image.asset(
                      naira,
                      width: 18,
                      height: 18,
                      color: color,
                    ),
                    addSpaceWidth(5),
                    Text(
                      amount,
                      style: textStyle(true, 25, color),
                    )
                  ],),
                  addLine(.5,black.withOpacity(.1),0,10,0,10),
                  Row(
                    children: [
                      Text("${incoming ? "From:" : "To:"}",style: textStyle(true, 12, color),),
                      addSpaceWidth(5),
                      Flexible(
                        child: Text(
                          "${incoming?sender:recipient}",
                          style: textStyle(false, 14, black.withOpacity(.4)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  addLine(.5,black.withOpacity(.1),0,10,0,10),

                  Text(
                    "Transaction Hash",
                    style: textStyle(true, 16, black),
                  ),
                  addSpace(10),
                  Container(
//                      height: 50,
                  padding: EdgeInsets.fromLTRB(10,10,0,10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: default_white,
                      border: Border.all(color: black.withOpacity(.1),width: .5)
                    ),
                    child: Row(
                      children: [
//                        addSpaceWidth(10),
                        Flexible(fit: FlexFit.tight,
                            child: Text(hash,
                              style: textStyle(false,18,black.withOpacity(.5)),
//                              maxLines: 1,overflow: TextOverflow.ellipsis,
                            )
                        ),
                        addSpaceWidth(10),
                        Container(width: 40,height: 40,
                        child: FlatButton(onPressed: (){
                          Clipboard.setData(ClipboardData(text: hash));
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
                        StringBuffer sb = StringBuffer();
                        sb.write("OneBlock Transaction\n\n");
                        sb.write("Sender: ${sender}\n\n");
                        sb.write("Recipient: ${recipient}\n\n");
                        sb.write("Amount: ${"N$amount"}\n\n");
                        sb.write("Transaction Hash: ${hash}\n\n");
                        sb.write("Time: ${getChatDate(time)}\n\n");
                          Share.share(sb.toString().trim());

                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Share",
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
