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
import 'NewPin.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController fNameController = new TextEditingController();
  TextEditingController lNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordController1 = new TextEditingController();

  FocusNode focusFName = FocusNode();
  FocusNode focusLName = FocusNode();
  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();
  FocusNode focusPassword1 = FocusNode();

  bool fNameFocused = false;
  bool lNameFocused = false;
  bool emailFocused = false;
  bool passFocused = false;
  bool passFocused1 = false;

  bool passwordVisible = false;

  String pin = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusFName.addListener(() {
      fNameFocused = focusFName.hasFocus;
      setState(() {});
    });

    focusLName.addListener(() {
      lNameFocused = focusLName.hasFocus;
      setState(() {});
    });
    focusEmail.addListener(() {
      emailFocused = focusEmail.hasFocus;
      setState(() {});
    });
    focusPassword.addListener(() {
      passFocused = focusPassword.hasFocus;
      setState(() {});
    });

    focusPassword1.addListener(() {
      passFocused1 = focusPassword1.hasFocus;
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                    "Signup",
                    style: textStyle(false, 50, app_red),
                  ),
                  Text(
                    "Create a free account and start transaction with blockchain technology",
                    style: textStyle(false, 14, black),
                  ),
                  addSpace(20),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
//                    height: 50,
                    // decoration: BoxDecoration(
                    //     color: default_white,
                    //     borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: new TextField(
                      controller: fNameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      focusNode: focusFName,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(
                          Icons.person,
                          color: fNameFocused ? red0 : black.withOpacity(.1),
                          size: 25,
                        ),
                        labelStyle: textStyle(
                          false,
                          22,
                          black.withOpacity(.35),
                        ),
                        labelText: "First Name",
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
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                    height: 50,
                    // decoration: BoxDecoration(
                    //     color: default_white,
                    //     borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: new TextField(
                      controller: lNameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      focusNode: focusLName,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(
                          Icons.person,
                          color: lNameFocused ? red0 : black.withOpacity(.1),
                          size: 25,
                        ),
                        labelStyle: textStyle(
                          false,
                          22,
                          black.withOpacity(.35),
                        ),
                        labelText: "Last Name",
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
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    // padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
//                    height: 50,
                    // decoration: BoxDecoration(
                    //     color: default_white,
                    //     borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: new TextField(
                      controller: passwordController1,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      focusNode: focusPassword1,
                      decoration: InputDecoration(
//                          hintText: "Password",
                          isDense: true,
                          labelText: "Retype Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: passFocused1 ? red0 : black.withOpacity(.1),
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
                          signup();
                        },
                        child: Text(
                          "Create Account",
                          style: textStyle(true, 20, white),
                        )),
                  ),
                  addSpace(15),
                  Center(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Already have an account? ",
                            style: textStyle(false, 14, black)),
                        TextSpan(
                          text: "Login",
                          style: textStyle(true, 13, red0),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              print("Tapped");
                              Navigator.pop(context);
                            },
                        ),
                      ]),
                      textAlign: TextAlign.center,
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

  void signup() async {
    String firstName = fNameController.text.trim();
    String lastName = fNameController.text.trim();
    String email = emailController.text.toLowerCase().trim();
    String password = passwordController.text;
    String password1 = passwordController1.text;

    if (firstName.isEmpty) {
      FocusScope.of(context).requestFocus(focusFName);
      showError("Enter your first name");
      return;
    }

    if (lastName.isEmpty) {
      FocusScope.of(context).requestFocus(focusLName);
      showError("Enter your last name");
      return;
    }
    if (!isEmailValid(email)) {
      FocusScope.of(context).requestFocus(focusEmail);
      showError(email.isEmpty ? "Enter your email" : "Invalid email address");
      return;
    }

    if (password.length < 4) {
      FocusScope.of(context).requestFocus(focusPassword);
      showError(
          password.isEmpty ? "Enter your password" : "Password too short");
      return;
    }

    if (password != password1) {
      FocusScope.of(context).requestFocus(focusPassword1);
      showError(password1.isEmpty
          ? "Retype your password"
          : "Password does not match");
      return;
    }

    if (pin.isNotEmpty) {
      startSignup(firstName, lastName, email, password, pin);
      return;
    }
    pushAndResult(context, NewPin(), result: (_) {
      Future.delayed(Duration(milliseconds: 200), () {
        pushAndResult(
            context,
            NewPin(
              defPin: _,
            ), result: (_) {
          Future.delayed(Duration(milliseconds: 200), () {
            pin = _;
            startSignup(firstName, lastName, email, password, _);
          });
        });
      });
    });
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

  startSignup(String firstName, String lastName, String email, String password,
      String pin) async {
    bool connected = await isConnected();
    if (!connected) {
      showError("No Internet Connectivity");
      return;
    }

    showProgress(true, context, msg: "Creating Account");

    getApplicationsAPICall(
      context,
      BASE_API + "auth/register",
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
        pref.setString(PIN, pin);
        userInfo = map;
        showMessage(context, Icons.check, blue0, "Successful",
            "Account created successfully",
            cancellable: false, onClicked: (_) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
            return MainActivity();
          }));
        });
      },
      post: {'email': email, 
             'password': password,
             "firstName":firstName,
             "lastName":lastName,
             "transactionPin":pin,
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
