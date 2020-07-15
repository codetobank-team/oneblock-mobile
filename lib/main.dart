//FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
import 'dart:convert';

import 'package:Oneblock/LoginPage.dart';
import 'package:Oneblock/MainActivity.dart';
import 'package:Oneblock/assets.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppEngine.dart';
import 'assets.dart';

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext c) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Oneblock",
        color: white,
        theme: ThemeData(fontFamily: 'Nirmala',focusColor: app_red),
        home: MainHome());
  }
}

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(color:white,child:loadingLayout());
  }

  checkUser() async {
    var pref = await SharedPreferences.getInstance();
    String userString = pref.getString(USER_INFO);
    if (userString == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
        return LoginPage();
      }));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
        String string = jsonDecode(userString);
        userInfo = jsonDecode(string);
//        userInfo = User.fromJson(map);
//        isAdmin =  userInfo.user_details.email.toLowerCase()=="dipopo@gmail.com"||
//            userInfo.user_details.email.toLowerCase()=="johnebere58@gmail.com";
//        print("User Token: ${userInfo.token}");
        return MainActivity();
      }));
    }
  }
}
