import 'dart:async';
import 'dart:convert';

import 'dart:ui';
import 'package:Oneblock/EnterPin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_plugin_qr_scanner/flutter_plugin_qr_scanner.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:Oneblock/AppEngine.dart';
import 'package:Oneblock/assets.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'MainActivity.dart';
import 'SignupPage.dart';

class SendMoney extends StatefulWidget {
  @override
  _SendMoneyState createState() {
    return _SendMoneyState();
  }
}

class _SendMoneyState extends State<SendMoney> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController accountController = new TextEditingController();
  MoneyMaskedTextController amountController =
  new MoneyMaskedTextController(initialValue: 0,decimalSeparator: ".",thousandSeparator: ",");
  TextEditingController refController = new TextEditingController();

  FocusNode focusAccount = FocusNode();
  FocusNode focusAmount = FocusNode();
  FocusNode focusRef = FocusNode();

  bool accountFocused = false;
  bool amountFocused = false;
  bool refFocused = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusAccount.addListener(() {
      accountFocused = focusAccount.hasFocus;
      setState(() {});
    });
    focusAmount.addListener(() {
      amountFocused = focusAmount.hasFocus;
      setState(() {});
    });
    focusRef.addListener(() {
      refFocused = focusRef.hasFocus;
      setState(() {});
    });

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
          child: new SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  addSpace(20),
                  Text(
                    "Send",
                    style: textStyle(false, 50, app_red),
                  ),

                  addSpace(30),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    height: 50,
                    // decoration: BoxDecoration(
                    //     color: default_white,
                    //     borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      children: [
                        Flexible(fit: FlexFit.tight,
                          child: new TextField(
                            controller: accountController,
//                      keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            focusNode: focusAccount,
                            decoration: InputDecoration(
                              isDense: true,
//                        suffix: GestureDetector(
//                          onTap: () {
//                            pushAndResult(context,ScanBarCode());
//                          },
//                          child: Icon(Icons.settings_overscan)),
                              labelStyle: textStyle(
                                false,
                                22,
                                black.withOpacity(.35),
                              ),
                              labelText: "Receiver ID",
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: red0, width: 2)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: black.withOpacity(.1), width: 1)),
                            ),
                            style: textStyle(
                              false,
                              22,
                              black,
                            ),
                            cursorColor: black,
                            cursorWidth: 1,
                            maxLines: 1,
                          ),
                        ),
//                        addSpaceWidth(10),
//                        Container(width: 40,height: 40,
//                          child: FlatButton(onPressed: (){
//                            initCodeState();
//                          },
//                              padding: EdgeInsets.all(0),
//                              child: Icon(Icons.settings_overscan,size: 18,)),)
                      ],
                    ),
                  ),
                  addSpace(20),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    height: 50,
                    // decoration: BoxDecoration(
                    //     color: default_white,
                    //     borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: new TextField(
                      controller: amountController,
//                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      focusNode: focusAmount,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Image.asset(naira,height: 15,width: 15,
                          color: amountFocused?red0:black.withOpacity(.1),),prefixIconConstraints: BoxConstraints(
                        minWidth: 40,
                        maxWidth: 40,
                          maxHeight: 15
                      ),
                        labelStyle: textStyle(
                          false,
                          22,
                          black.withOpacity(.35),
                        ),
                        labelText: "Amount",
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: red0, width: 2)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: black.withOpacity(.1), width: 1)),
                      ),
                      style: textStyle(
                        false,
                        22,
                        black,
                      ),
                      cursorColor: black,
                      cursorWidth: 1,
                      maxLines: 1,
                    ),
                  ),
                  addSpace(20),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    height: 50,
                    // decoration: BoxDecoration(
                    //     color: default_white,
                    //     borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: new TextField(
                      controller: refController,
//                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      focusNode: focusRef,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: textStyle(
                          false,
                          22,
                          black.withOpacity(.35),
                        ),
                        labelText: "Reference Note ${!refFocused?"(Optional)":""}",
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: red0, width: 2)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: black.withOpacity(.1), width: 1)),
                      ),
                      style: textStyle(
                        false,
                        22,
                        black,
                      ),
                      cursorColor: black,
                      cursorWidth: 1,
                      maxLines: 1,
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
                        onPressed: () {
//                          send();
                        pushAndResult(context, EnterPin());
                        },
                        child: Text(
                          "Send",
                          style: textStyle(true, 20, white),
                        )),
                  ),
                  addSpace(50),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void send() async {
    String account = accountController.text.trim();
    double amount = amountController.numberValue;
    String ref = refController.text;

    if (account.isEmpty) {
      FocusScope.of(context).requestFocus(focusAccount);
      showError(account.isEmpty ? "Enter receiver id" : "Invalid receiver id");
      return;
    }

    if (amount==0) {
      FocusScope.of(context).requestFocus(focusAmount);
      showError("Enter amount");
      return;
    }

//    startSending();
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

  startLogin(String email, String password) async {
    bool connected = await isConnected();
    if (!connected) {
      showError("No Internet Connectivity");
      return;
    }

    showProgress(true, context,);

    getApplicationsAPICall(
      context,
      BASE_API + "auth/login",
      (response, error) async {
        showProgress(false, context);
        if (error != null) {
          Future.delayed(Duration(milliseconds: 500), () {
            showMessage(
                context, Icons.error, red0, "Error occurred", error.toString());
          });
          return;
        }
        print("Api response: ${response.body}");

        String body = response.body;
        Map responseBody = jsonDecode(body);
        if (body.toString().contains("error")) {
          Future.delayed(Duration(milliseconds: 500), () {
            showMessage(context, Icons.error, red0, "Error occurred",
                "${responseBody["error"]}");
          });
          return;
        }
        // Api response: {"status":201,"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
        // eyJpZCI6IjVmMGU1NTJlYjM0NmVmMDAxZWYzYzcxZSIsImlhdCI6MTU5NDc3NDgzMSwiZXhwIjo
        // xNTk0Nzc2NjMxfQ.cHxLz58nyDxv-WR8bM78NDf0Ro23whq3uNaUcgwRHWE","
        // data":{"id":"5f0e552eb346ef001ef3c71e",
        // "firstName":"John","lastName":"John","email":"john@gmail.com"}}

        var pref = await SharedPreferences.getInstance();
        String json = jsonEncode(body);
        Map map = jsonDecode(body);
        pref.setString(USER_INFO, json);
        pref.setString(USER_INFO_BACKUP, json);
        pref.setString(EMAIL, email);
        pref.setString(PASSWORD, password);
        userInfo = map;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
          return MainActivity();
        }));
      },
      post: {
        'email': email,
        'password': password,
      },
    );
  }
// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initCodeState() async {
    String code;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      code = await QrScanner.scan(
        title: "scanner",
        laserColor: Colors.white, //default #ffff55ff
        playBeep: true, //default false
        promptMessage: "Point the QR code to the frame to complete the scan.",
        errorMsg: "Oops, something went wrong. You may need to check your permission of camera or restart the device.",
        permissionDeniedText: "Your privacy settings seem to prevent us from accessing your camera for barcode scanning. You can fix it by doing this, touch the OK button below to open the Settings and then turn the Camera on.",
        messageConfirmText: "OK",
        messageCancelText: "Cancel",
      );
    } on PlatformException {
      code = 'Failed to get qr code.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      showError(code);
    });
  }

}

