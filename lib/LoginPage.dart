import 'dart:async';
import 'dart:convert';

import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:Oneblock/AppEngine.dart';
import 'package:Oneblock/assets.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'MainActivity.dart';
import 'SignupPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();

  bool emailFocused = false;
  bool passFocused = false;

  bool passwordVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusEmail.addListener(() {
      emailFocused = focusEmail.hasFocus;
      setState(() {});
    });
    focusPassword.addListener(() {
      passFocused = focusPassword.hasFocus;
      setState(() {});
    });

    load();
  }

  String myPass = "";
  String myEmail = "";
  bool canUseFinger = false;
  load() async {
    var pref = await SharedPreferences.getInstance();
    myEmail = pref.getString(EMAIL);
    myPass = pref.getString(PASSWORD);
    emailController.text = myEmail;
    canUseFinger = myEmail != null;
    setState(() {});
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

  final LocalAuthentication auth = LocalAuthentication();
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
    } catch (e) {
      print(e);
    }
    if (!mounted) return;

    if (authenticated) {
      /*var pref = await SharedPreferences.getInstance();
      String userString = pref.getString(USER_INFO_BACKUP);
      pref.setString(USER_INFO, userString);
      String string = jsonDecode(userString);
      Map map = jsonDecode(string);
      userInfo = User.fromJson(map);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
        return MainActivity();
      }));*/
      startLogin(myEmail, myPass);
    }
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
                    "Login",
                    style: textStyle(false, 50, app_red),
                  ),
                  Text(
                    "Securely login to OneBlock",
                    style: textStyle(false, 14, black),
                  ),

                  addSpace(30),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
//                    height: 50,
                    // decoration: BoxDecoration(
                    //     color: default_white,
                    //     borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: new TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      focusNode: focusEmail,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(Icons.email,
                            color: emailFocused ? red0 : black.withOpacity(.1)),
                        labelStyle: textStyle(
                          false,
                          22,
                          black.withOpacity(.35),
                        ),
                        labelText: "Email",
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
//              addLine(2, black.withOpacity(.1), 20, 0, 20, 10),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    // padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
//                    height: 50,
                    // decoration: BoxDecoration(
                    //     color: default_white,
                    //     borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: new TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      focusNode: focusPassword,
                      decoration: InputDecoration(
//                          hintText: "Password",
                          isDense: true,
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: passFocused ? red0 : black.withOpacity(.1),
                          ),
                          suffix: GestureDetector(
                              onTap: () {
                                passwordVisible = !passwordVisible;
                                setState(() {});
                              },
                              child: Text(
                                passwordVisible ? "HIDE" : "SHOW",
                                style:
                                    textStyle(false, 12, black.withOpacity(.5)),
                              )),
                          labelStyle: textStyle(
                            false,
                            22,
                            black.withOpacity(.35),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: red0, width: 2)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: black.withOpacity(.1), width: 1))),
                      style: textStyle(
                        false,
                        22,
                        black,
                      ),
                      obscureText: !passwordVisible,
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
                          login();
                        },
                        child: Text(
                          "Login",
                          style: textStyle(true, 20, white),
                        )),
                  ),
                  addSpace(15),
                  // if (canUseFinger)
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (myPass==null) {
                          showMessage(context, Icons.error, red0, "Login First",
                              "You need to make an initial login, before you can use fingerprint");
                          return;
                        }

                        _authenticate();
                      },
                      child: Container(
                        height: 40,
                        // margin: EdgeInsets.only(top: 15, left: 0, right: 20),
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: BoxDecoration(
                            // color: red3,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            border: Border.all(color: red0, width: 1)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.fingerprint,
                              size: 14,
                              color: red0,
                            ),
                            addSpaceWidth(5),
                            new Text(
                              "Use Fingerprint",
                              style: textStyle(true, 14, red0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  addSpace(15),
                  Center(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Don't have an account? ",
                            style: textStyle(false, 14, black)),
                        TextSpan(
                          text: "Signup",
                          style: textStyle(true, 13, red0),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              print("Tapped");
                              pushAndResult(context, SignupPage());
                            },
                        ),
                      ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  addSpace(10),
                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: new Text(
                        "Forgot Password?",
                        style: textStyle(true, 14, black),
                      ),
                    ),
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

  Future<Null> biometrics() async {
    final LocalAuthentication auth = new LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: false);
    } catch (e) {
      print(e);
    }
    print("$authenticated");
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (!isEmailValid(email)) {
      FocusScope.of(context).requestFocus(focusEmail);
      showError(email.isEmpty ? "Enter your email" : "Invalid email address");
      return;
    }

    if (password.length < 6) {
      FocusScope.of(context).requestFocus(focusPassword);
      showError(
          password.isEmpty ? "Enter your password" : "Password too short");
      return;
    }

    startLogin(email, password);
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

    showProgress(true, context, msg: "Logging In");

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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
/*

class PassCodeScreen extends StatefulWidget {
  @override
  _PassCodeScreenState createState() => _PassCodeScreenState();
}

class _PassCodeScreenState extends State<PassCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('Can check biometrics: $_canCheckBiometrics\n'),
                RaisedButton(
                  child: const Text('Check biometrics'),
                  onPressed: _checkBiometrics,
                ),
                Text('Available biometrics: $_availableBiometrics\n'),
                RaisedButton(
                  child: const Text('Get available biometrics'),
                  onPressed: _getAvailableBiometrics,
                ),
                Text('Current State: $_authorized\n'),
                RaisedButton(
                  child: Text(_isAuthenticating ? 'Cancel' : 'Authenticate'),
                  onPressed:
                  _isAuthenticating ? _cancelAuthentication : _authenticate,
                )
              ])),
    );
  }


  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    }  catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    }  catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    }  catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }
}
*/
