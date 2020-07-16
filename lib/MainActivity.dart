import 'dart:ui';
import 'dart:io' as io;

import 'package:Oneblock/AppEngine.dart';
import 'package:Oneblock/Settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Assets.dart';
import 'MainPage1.dart';

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity>
    with WidgetsBindingObserver {
  PageController pageController = PageController();
  int currentPage = 0;
  bool setup = false;
  String noInternetText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          io.exit(0);
          return;
        },
        child: Scaffold(
          body: body(),
          backgroundColor: white,
        ));
  }

  body() {
    return Column(
      children: [
        Expanded(
            child: PageView(
          onPageChanged: (int p) {
            setState(() {
              currentPage = p;
            });
          },
          controller: pageController,
          children: [
            MainPage1(),
            Container(
              margin: EdgeInsets.only(top: 50),
              child:emptyLayout(Icons.trending_up, "Nothing to display", "")
            ),
            Settings(),
          ],
        )),
        addLine(.5,black.withOpacity(.1),0,0,0,0),
        addSpace(5),
        Row(
          children: [
            bottomTab(Icons.account_balance_wallet, 0, 20),
            bottomTab(Icons.trending_up, 1, 25),
            bottomTab(Icons.settings, 2, 20),
          ],
        ),
        addSpace(5),
      ],
    );
  }

  bottomTab(icon, int p, double size) {
    bool selected = currentPage == p;
    var color = black.withOpacity(selected ? 1 : (.3));
    size = selected ? (size + 5) : size;
    return Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: GestureDetector(
            onTap: () {
              pageController.jumpToPage(p);
            },
            child: Container(
                color: transparent,
                child: Center(
                    child: Container(
                        width: 45,
                        height: 45,
                        child: Stack(children: [
                          Center(
                              child: icon is String
                                  ? (Image.asset(icon,
                                      width: size, height: size, color: color))
                                  : (Icon(icon, size: size, color: color))),
                        ]))))));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.paused) {}
    if (state == AppLifecycleState.resumed) {
      // checkConnectivity();

    }

    super.didChangeAppLifecycleState(state);
  }

  checkConnectivity() async {
    if (!(await isConnected())) {
      noInternetText = "No Internet Connectivity";
      Future.delayed(Duration(seconds: 5), () {
        noInternetText = "";
        setState(() {});
      });
    }
//    checkInternet(onChecked: (bool connected) {
//      if (connected) return;
//      noInternetText = "No Internet Connectivity";
//      Future.delayed(Duration(seconds: 5), () {
//        noInternetText = "";
//        setState(() {});
//      });
//    });
  }
}
