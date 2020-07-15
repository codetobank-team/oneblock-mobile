
import 'dart:ui';
import 'dart:io' as io;

import 'package:Oneblock/AppEngine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Assets.dart';

List rolesList = [];
List departmentsList = [];
List suppliersList = [];
List productsList = [];
List productCategoriesList = [];
List listOfMyProducts = [];
List assetCategoriesList = [];
List inventoryItemsList = [];
List serviceCategoryList = [];
List locationList = [];
List customerList = [];
List requestTypeList = [];
List approverList = [];
//List alloteeList = [];

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> with WidgetsBindingObserver{

  PageController pageController = PageController();
  int currentPage = 0;
  bool setup=false;
  String noInternetText = "";
  double butSize = 100;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkReceiptTip();
  }

  bool showIntro = false;
  checkReceiptTip() async {
    Future.delayed(Duration(seconds: 3),()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("receipt2") == null) {
      prefs.setBool("receipt2", true);
      showIntro = true;
      setState(() {});
      animateTip();
    }
    });
  }

  animateTip()async{
    if(!showIntro)return;
    Future.delayed(Duration(milliseconds: 750),(){
      butSize = butSize==100?50:100;
      setState(() {});
      animateTip();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      title: "Oneblock",
      color: white,
      home: WillPopScope(
        onWillPop: (){
    io.exit(0);
    return;
    },child: Scaffold(
          body: Container(
            color: white,
            child: Stack(fit: StackFit.expand,
              children: [
                body(),
                if(showIntro)Container(
                  child: Stack(
                    children: [
                      BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                          child: Container(
                            color: black.withOpacity(.7),
                          )),
                      Center(
                        child: Container(
                          margin: EdgeInsets.all(30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Click here to quickly capture receipts",style: textStyle(true, 25, white),
                              textAlign: TextAlign.center,),
                              addSpace(20),
                              Container(
                                height: 50,
                                child: FlatButton(
                                    materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)),
                                    color: white,
                                    onPressed: () {
                                      showIntro = false;
                                      setState(() {});
                                    },
                                    child: Text(
                                      "Got It",
                                      style: textStyle(true, 20, app_blue),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0,0,0,20),
                          width: 100,height: 100,
                          child: Stack(
                            children: [
                              Center(
                                child: AnimatedContainer(
                                  width: butSize,height: butSize,duration: Duration(milliseconds: 500),
                                  decoration: BoxDecoration(
                                      color: white,shape: BoxShape.circle
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),

              ],
            )
          ),
        ),
      ),
    );
  }

  body(){
    return Container();
  }

  bottomTab(icon, int p,double size) {
    bool selected = currentPage == p;
    var color = blue3.withOpacity(selected ? 1 : (.3));
    size = selected?(size+5):size;
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
    if (state == AppLifecycleState.paused) {

    }
    if (state == AppLifecycleState.resumed) {
      checkConnectivity();

    }

    super.didChangeAppLifecycleState(state);
  }

  checkConnectivity()async{
    if(!(await isConnected())){
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
