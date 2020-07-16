import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Oneblock/assets.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart' as dioLib;
import 'package:Oneblock/dialogs/countryDialog.dart';
import 'package:country_pickers/country.dart';
import 'package:http/http.dart' as http;
import 'package:Oneblock/dialogs/listDialog.dart';
import 'package:Oneblock/dialogs/messageDialog.dart';
import 'package:Oneblock/dialogs/progressDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'LoginPage.dart';
import 'dialogs/fullMessageDialog.dart';

SizedBox addSpace(double size) {
  return SizedBox(
    height: size,
  );
}

addSpaceWidth(double size) {
  return SizedBox(
    width: size,
  );
}

int getSeconds(String time) {
  List parts = time.split(":");
  int mins = int.parse(parts[0]) * 60;
  int secs = int.parse(parts[1]);
  return mins + secs;
}

String getTimerText(int seconds, {bool three = false}) {
  int hour = seconds ~/ Duration.secondsPerHour;
  int min = (seconds ~/ 60) % 60;
  int sec = seconds % 60;

  String h = hour.toString();
  String m = min.toString();
  String s = sec.toString();

  String hs = h.length == 1 ? "0$h" : h;
  String ms = m.length == 1 ? "0$m" : m;
  String ss = s.length == 1 ? "0$s" : s;

  return three ? "$hs:$ms:$ss" : "$ms:$ss";
}

Container addLine(
    double size, color, double left, double top, double right, double bottom) {
  return Container(
    height: size,
    width: double.infinity,
    color: color,
    margin: EdgeInsets.fromLTRB(left, top, right, bottom),
  );
}

Container bigButton(double height, double width, String text, textColor,
    buttonColor, onPressed) {
  return Container(
    height: height,
    width: width,
    child: RaisedButton(
      onPressed: onPressed,
      color: buttonColor,
      textColor: white,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 20,
            fontFamily: "NirmalaB",
            fontWeight: FontWeight.normal,
            color: textColor),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

Container boxedText(text, int key, int keyHolder, Color normalColor,
    Color selectedColor, Color normalTextColor, Color selectedTextColor) {
  bool selected = key == keyHolder;
  return Container(
    height: 45,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: selected ? selectedColor : null,
        border: !selected
            ? Border.all(width: 1, color: normalColor, style: BorderStyle.solid)
            : null),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 15,
              fontFamily: "NirmalaB",
              fontWeight: FontWeight.normal,
              color: selected ? selectedTextColor : normalTextColor),
        ),
      ),
    ),
  );
}

Future<File> loadFile(String path, String name) async {
  final ByteData data = await rootBundle.load(path);
  Directory tempDir = await getTemporaryDirectory();
  File tempFile = File('${tempDir.path}/$name');
  await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
  return tempFile;
}

textStyle(bool bold, double size, color,
    {underlined = false, bool withShadow = false, bool love = false}) {
  return TextStyle(
      color: color,
      fontWeight: FontWeight.normal,
      fontFamily:
          love ? (!bold ? "curve" : "curveB") : bold ? "NirmalaB" : "Nirmala",
      fontSize: size,
      shadows: !withShadow
          ? null
          : (<Shadow>[
              Shadow(offset: Offset(4.0, 4.0), blurRadius: 6.0, color: black),
            ]),
      decoration: underlined ? TextDecoration.underline : TextDecoration.none);
}

placeHolder(double height, {double width = 200}) {
  return new Container(
    height: height,
    width: width,
    color: blue0.withOpacity(.1),
    child: Center(
        child: Opacity(
            opacity: .3,
            child: Image.asset(
              ic_launcher,
              width: 20,
              height: 20,
            ))),
  );
}

tipBox(boxColor, String text, textColor, {margin}) {
  return Container(
    //width: double.infinity,
    margin: margin,
    decoration:
        BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        //mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            Icons.info,
            size: 14,
            color: white,
          ),
          addSpaceWidth(10),
          Flexible(
            flex: 1,
            child: Text(
              text,
              style: textStyle(false, 15, textColor),
            ),
          )
        ],
      ),
    ),
  );
}

textBox(title, icon, mainText, tap) {
  return new Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        title,
        style: textStyle(false, 14, white.withOpacity(.5)),
      ),
      addSpace(10),
      new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Image.asset(
            icon,
            width: 14,
            height: 14,
            color: white,
          ),
          addSpaceWidth(15),
          Flexible(
            flex: 1,
            child: Column(
              children: <Widget>[
                new Container(
                  width: double.infinity,
                  child: InkWell(
                      onTap: tap,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          mainText,
                          style: textStyle(false, 17, white),
                        ),
                      )),
                ),
                addLine(2, white, 0, 0, 0, 0),
              ],
            ),
          )
        ],
      ),
    ],
  );
}

Widget transition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

loadingLayout({bool trans = false}) {
  return new Container(
//    color: trans ? transparent : white,
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Center(
          child: Opacity(
            opacity: 1,
            child: Image.asset(
              ic_launcher,
              width: 20,
              height: 20,
            ),
          ),
        ),
        Center(
          child: CircularProgressIndicator(
            //value: 20,
            valueColor: AlwaysStoppedAnimation<Color>(trans ? white : red0),
            strokeWidth: 2,
          ),
        ),
      ],
    ),
  );
}

errorDialog(retry, cancel, {String text}) {
  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Container(
        color: black.withOpacity(.8),
      ),
      Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: red0,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: Text(
                        "!",
                        style: textStyle(true, 30, white),
                      ))),
                  addSpace(10),
                  Text(
                    "Error",
                    style: textStyle(false, 14, red0),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              text == null ? "An unexpected error occurred, try again" : text,
              style: textStyle(false, 14, white.withOpacity(.5)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
      Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: new Container(),
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FlatButton(
                      onPressed: retry,
                      child: Text(
                        "RETRY",
                        style: textStyle(true, 15, white),
                      )),
                ),
                addSpace(15),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FlatButton(
                      onPressed: cancel,
                      child: Text(
                        "CANCEL",
                        style: textStyle(true, 15, white),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    ],
  );
}

addExpanded() {
  return Expanded(
    child: new Container(),
    flex: 1,
  );
}

addFlexible() {
  return Flexible(
    child: new Container(),
    flex: 1,
    fit: FlexFit.tight,
  );
}

emptyLayout(icon, String title, String text, {click, clickText}) {
  return Container(
    color: white,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              width: 50,
              height: 50,
              child: Stack(
                children: <Widget>[
                  new Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: app_red, width: 2)),
                  ),
                  new Center(
                      child: !(icon is String)
                          ? Icon(
                              icon,
                              size: 30,
                              color: app_red,
                            )
                          : Image.asset(
                              icon,
                              height: 30,
                              width: 30,
                              color: app_red,
                            )),
                  /*  new Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        addExpanded(),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: red3,
                              shape: BoxShape.circle,
//                              border: Border.all(color: white, width: 1)
                          ),
                          child: Center(
                            child: Text(
                              "!",
                              style: textStyle(true, 14, white),
                            ),
                          ),
                        )
                      ],
                    ),
                  )*/
                ],
              ),
            ),
            addSpace(10),
            Row(mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: textStyle(true, 16, black),
                  textAlign: TextAlign.center,
                ),
//                if(click!=null)GestureDetector(
//                  onTap: (){
//                    click();
//                  },
//                  child: Container(
//                      padding: EdgeInsets.all(5),
//                      decoration: BoxDecoration(color: red6,shape: BoxShape.circle)
//                      ,child: Icon(Icons.refresh,color: white,size: 14,)),
//                )
              ],
            ),
            if(text.isNotEmpty)addSpace(5),
            if(text.isNotEmpty)Text(
              text,
              style: textStyle(false, 14, black.withOpacity(.5)),
              textAlign: TextAlign.center,
            ),
            if(click!=null)addSpace(10),
            if(click!=null)Container(height: 30,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),side: BorderSide(width: 1,color:black.withOpacity(.1))),
//                      color: default_white,
                      onPressed: click,
                      padding: EdgeInsets.fromLTRB(10,5,10,5),
                      child: Text(
                        clickText,
                        style: textStyle(false, 14, black.withOpacity(.7)),
                      )),
                )
          ],
        ),
      ),
    ),
  );
}

emptyLayoutList(icon, String title, String text, double height,
    {click, clickText}) {
  return ListView(
    physics: NeverScrollableScrollPhysics(),
    children: [
      Container(
//        color: white,
        height: height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  width: 50,
                  height: 50,
                  child: Stack(
                    children: <Widget>[
                      new Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: app_blue, width: 2)),
                      ),
                      new Center(
                          child: !(icon is String)
                              ? Icon(
                                  icon,
                                  size: 30,
                                  color: app_blue,
                                )
                              : Image.asset(
                                  icon,
                                  height: 30,
                                  width: 30,
                                  color: app_blue,
                                )),
                    ],
                  ),
                ),
                addSpace(10),
                Text(
                  title,
                  style: textStyle(true, 16, black),
                  textAlign: TextAlign.center,
                ),
                addSpace(5),
                Text(
                  text,
                  style: textStyle(false, 14, black.withOpacity(.5)),
                  textAlign: TextAlign.center,
                ),
                addSpace(10),
                click == null
                    ? new Container()
                    : FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: app_blue,
                        onPressed: click,
                        child: Text(
                          clickText,
                          style: textStyle(true, 14, white),
                        ))
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

String getChatDate(int milli) {
  final formatter = DateFormat("MMM d 'AT' h:mm a");
  DateTime date = DateTime.fromMillisecondsSinceEpoch(milli);
  return formatter.format(date);
}

pushAndResult(context, item, {result}) {
  Navigator.push(
      context,
      PageRouteBuilder(
          transitionsBuilder: transition,
          opaque: false,
          pageBuilder: (context, _, __) {
            return item;
          })).then((_) {
    if (_ != null) {
      if (result != null) result(_);
    }
  });
}

String getRandomId() {
  var uuid = new Uuid();
  return uuid.v1();
}

String getCountryCode(context) {
  return Localizations.localeOf(context).countryCode;
}

String getExtImage(String fileExtension) {
  if (fileExtension == null) return "";
  fileExtension = fileExtension.toLowerCase().trim();
  if (fileExtension.contains("doc")) {
    return icon_file_doc;
  } else if (fileExtension.contains("pdf")) {
    return icon_file_pdf;
  } else if (fileExtension.contains("xls")) {
    return icon_file_xls;
  } else if (fileExtension.contains("ppt")) {
    return icon_file_ppt;
  } else if (fileExtension.contains("txt")) {
    return icon_file_text;
  } else if (fileExtension.contains("zip")) {
    return icon_file_zip;
  } else if (fileExtension.contains("xml")) {
    return icon_file_xml;
  } else if (fileExtension.contains("png") ||
      fileExtension.contains("jpg") ||
      fileExtension.contains("jpeg")) {
    return icon_file_photo;
  } else if (fileExtension.contains("mp4") ||
      fileExtension.contains("3gp") ||
      fileExtension.contains("mpeg") ||
      fileExtension.contains("avi")) {
    return icon_file_video;
  } else if (fileExtension.contains("mp3") ||
      fileExtension.contains("m4a") ||
      fileExtension.contains("m4p")) {
    return icon_file_audio;
  }

  return icon_file_unknown;
}

Future<bool> isConnected() async {
  var result = await (Connectivity().checkConnectivity());
  if (result == ConnectivityResult.none) {
    return Future<bool>.value(false);
  }
  return Future<bool>.value(true);
}

void showProgress(bool show, BuildContext context,
    {String msg, bool cancellable = true}) {
  if (!show) {
    progressDialogShowing = false;
    progressController.add(false);
    return;
  }
  progressDialogShowing = true;
  pushAndResult(
      context,
      progressDialog(
        message: msg,
        cancelable: cancellable,
      ));
}

void showMessage(
  context,
  icon,
  iconColor,
  title,
  message, {
  int delayInMilli = 0,
  clickYesText = "OK",
  onClicked(bool ok),
  clickNoText,
  bool cancellable = true,
  double iconPadding,
}) {
  Future.delayed(Duration(milliseconds: delayInMilli), () {
    pushAndResult(
        context,
        messageDialog(
          icon,
          iconColor,
          title,
          message,
          clickYesText,
          noText: clickNoText,
          cancellable: cancellable,
          iconPadding: iconPadding,
        ),
        result: onClicked);
  });
}

void showFullMessage(
  context,
  title,
  message, {
  int delayInMilli = 0,
  clickYesText = "OK",
  onClicked,
  clickNoText,
  bool cancellable = true,
}) {
  Future.delayed(Duration(milliseconds: delayInMilli), () {
    pushAndResult(
        context,
        fullMessageDialog(
          title,
          message,
          clickYesText,
          noText: clickNoText,
          cancellable: cancellable,
        ),
        result: onClicked);
  });
}

bool isEmailValid(String email) {
  if (!email.contains("@") || !email.contains(".")) return false;
  return true;
}

gradientLine({double height = 4, bool reverse = false, double alpha = .3}) {
  return Container(
    width: double.infinity,
    height: height,
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: reverse
                ? [
                    black.withOpacity(alpha),
                    transparent,
                  ]
                : [transparent, black.withOpacity(alpha)])),
  );
}

openLink(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

void yesNoDialog(context, title, message, clickedYes,
    {bool cancellable = true, color = red0}) {
  Navigator.push(
      context,
      PageRouteBuilder(
          transitionsBuilder: transition,
          opaque: false,
          pageBuilder: (context, _, __) {
            return messageDialog(
              Icons.warning,
              color,
              title,
              message,
              "Yes",
              noText: "No, Cancel",
              cancellable: cancellable,
            );
          })).then((_) {
    if (_ != null) {
      if (_ == true) {
        clickedYes();
      }
    }
  });
}

formatPrice(String price) {
  if (price.contains("000000")) {
    price = price.replaceAll("000000", "");
    price = "${price}M";
  } else if (price.length > 6) {
    double pr = (int.parse(price)) / 1000000;
    return "${pr.toStringAsFixed(1)}M";
  } else if (price.contains("000")) {
    price = price.replaceAll("000", "");
    price = "${price}K";
  } else if (price.length > 3) {
    double pr = (int.parse(price)) / 1000;
    return "${pr.toStringAsFixed(1)}K";
  }
  return price;
}

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> getLocalFile(String name) async {
  final path = await localPath;
  return File('$path/$name');
}

Future<File> getDirFile(String name) async {
  final dir = await getExternalStorageDirectory();
  var testDir = await Directory("${dir.path}/Oneblock").create(recursive: true);
  return File("${testDir.path}/$name");
}

String formatDuration(Duration position) {
  final ms = position.inMilliseconds;

  int seconds = ms ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  var minutes = seconds ~/ 60;
  seconds = seconds % 60;

  final hoursString = hours >= 10 ? '$hours' : hours == 0 ? '00' : '0$hours';

  final minutesString =
      minutes >= 10 ? '$minutes' : minutes == 0 ? '00' : '0$minutes';

  final secondsString =
      seconds >= 10 ? '$seconds' : seconds == 0 ? '00' : '0$seconds';

  final formattedTime =
      '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';

  return formattedTime;
}

int getPositionForLetter(String text) {
  return az.indexOf(text.toUpperCase());
}

String az = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
String getLetterForPosition(int position) {
  return az.substring(position, position + 1);
}

String convertListToString(String divider, List list) {
  StringBuffer sb = new StringBuffer();
  for (int i = 0; i < list.length; i++) {
    String s = list[i];
    sb.write(s);
//    sb.write(" ");
    if (i != list.length - 1) sb.write(divider);
    sb.write(" ");
  }

  return sb.toString().trim();
}

List<String> convertStringToList(String divider, String text) {
  List<String> list = new List();
  var parts = text.split(divider);
  for (String s in parts) {
    list.add(s.trim());
  }
  return list;
}

tipMessageItem(String title, String message) {
  return Container(
    //width: 300,
    //height: 300,
    child: new Card(
        color: red03,
        elevation: .5,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: new Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.info,
                    size: 14,
                    color: white,
                  ),
                  addSpaceWidth(5),
                  Text(
                    title,
                    style: textStyle(true, 12, white.withOpacity(.5)),
                  ),
                ],
              ),
              addSpace(5),
              Text(
                message,
                style: textStyle(false, 16, white),
                //overflow: TextOverflow.ellipsis,
              ),
              /*Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(3)),
                child: Text(
                  "APPLY",
                  style: textStyle(true, 9, black),
                ),
              ),*/
            ],
          ),
        )),
  );
}

placeCall(String phone) {
  openLink("tel://$phone");
}

sendEmail(String email) {
  openLink("mailto:$email");
}

tabIndicator(int tabCount, int currentPosition, {margin}) {
  return Container(
    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
    margin: margin,
    decoration: BoxDecoration(
        color: black.withOpacity(.7), borderRadius: BorderRadius.circular(25)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: getTabs(tabCount, currentPosition),
    ),
  );
  /*return Marker(
      markerId: MarkerId(""),
      infoWindow: InfoWindow(),
      icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(), ""));*/
}

getTabs(int count, int cp) {
  List<Widget> items = List();
  for (int i = 0; i < count; i++) {
    bool selected = i == cp;
    items.add(Container(
      width: selected ? 10 : 8,
      height: selected ? 10 : 8,
      //margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
          color: white.withOpacity(selected ? 1 : (.5)),
          shape: BoxShape.circle),
    ));
    if (i != count - 1) items.add(addSpaceWidth(5));
  }

  return items;
}

imageHolder(double size, imageUrl,
    {double stroke = 0,
    strokeColor = app_red,
    bool local = false,
    iconHolder = Icons.person,
    double iconHolderSize = 14,
    bool showDot = false}) {
  return new AnimatedContainer(
    curve: Curves.ease,
    duration: Duration(milliseconds: 300),
    width: size,
    height: size,
    child: Stack(
      children: <Widget>[
        AnimatedContainer(
          curve: Curves.ease,
          duration: Duration(milliseconds: 300),
          width: size,
          height: size,
          child: new Card(
            margin: EdgeInsets.all(0),
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
            color: strokeColor,
            elevation: 5,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Icon(
                    iconHolder,
                    color: white,
                    size: size / 3,
                  ),
                ),
                imageUrl is File
                    ? (Image.file(imageUrl))
                    : local
                        ? Image.asset(
                            imageUrl,
                            width: size,
                            height: size,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            width: size,
                            height: size,
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                          ),
              ],
            ),
          ),
        ),
        !showDot
            ? Container()
            : Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: white, width: 2),
                    color: red0,
                  ),
                )),
      ],
    ),
  );
}

String getExtToUse(String fileExtension) {
  if (fileExtension == null) return "";
  fileExtension = fileExtension.toLowerCase().trim();
  if (fileExtension.contains("doc")) {
    return "doc";
  } else if (fileExtension.contains("xls")) {
    return "xls";
  } else if (fileExtension.contains("ppt")) {
    return "ppt";
  }

  return fileExtension;
}

class ViewImage extends StatefulWidget {
  List images;
  int position;
  ViewImage(
    this.images,
    this.position,
  );
  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  List images;
  int position;

  @override
  void initState() {
    // TODO: implement initState
    images = widget.images;
    position = widget.position;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: position);
    List<PhotoViewGalleryPageOptions> list = List();
    for (String image in images) {
      list.add(PhotoViewGalleryPageOptions(
        imageProvider:
            (image.startsWith("https://") || image.startsWith("http://"))
                ? NetworkImage(image)
                : FileImage(File(image)),
        initialScale: PhotoViewComputedScale.contained,
        /* maxScale: PhotoViewComputedScale.contained * 0.3*/
      ));
    }
    // TODO: implement build
    return Container(
      color: black,
      child: Stack(children: <Widget>[
        PhotoViewGallery(
          pageController: controller,
          pageOptions: list,
          onPageChanged: (p) {
            position = p;
            setState(() {});
          },
        ),
        new Container(
          margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
          width: 50,
          height: 50,
          child: FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Center(
                child: Icon(
              Icons.keyboard_backspace,
              color: white,
              size: 25,
            )),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(flex: 1, child: Container()),
            new Padding(
              padding: const EdgeInsets.all(20),
              child: tabIndicator(images.length, position),
            ),
          ],
        )
      ]),
    );
  }
}

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;
  final bool round;
  final bool addShadow;

  const RaisedGradientButton(
      {Key key,
      @required this.child,
      this.gradient,
      this.width = double.infinity,
      this.height = 50.0,
      this.onPressed,
      this.addShadow = true,
      this.round = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: round ? null : BorderRadius.circular(25),
          boxShadow: !addShadow
              ? null
              : [
                  BoxShadow(
                    color: Colors.grey[500],
                    offset: Offset(0.0, 1.5),
                    blurRadius: 1.5,
                  ),
                ],
          shape: round ? BoxShape.circle : BoxShape.rectangle),
      child: Material(
        color: Colors.transparent,
        child: FlatButton(
            shape: round
                ? CircleBorder()
                : RoundedRectangleBorder(
                    borderRadius: round ? null : BorderRadius.circular(25),
                  ),
            color: Colors.transparent,
            onPressed: onPressed,
            padding: EdgeInsets.all(0),
            child: Center(
              child: child,
            )),
      ),
    );
  }
}

Future<void> toastInAndroid(String text) async {
  const platform = const MethodChannel("channel.john");
  try {
    await platform.invokeMethod('toast', <String, String>{'message': text});
  } on PlatformException catch (e) {
    //batteryLevel = "Failed to get what he said: '${e.message}'.";
  }
}

nameItem(
  String title,
  String text, {
  color: app_blue,
  love = false,
  bool singleLine = false,
  double fontSize: 12,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 5),
    child: RichText(
        text: TextSpan(children: [
      TextSpan(
          text: title, style: textStyle(true, fontSize, color, love: love)),
      TextSpan(
          text: "$text",
          style: textStyle(false, fontSize + 1, color.withOpacity(.5)))
    ])),
  );
}

checkBox(bool selected, {double size: 13, checkColor = blue6}) {
  return new Container(
    //padding: EdgeInsets.all(2),
    child: Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: blue09,
          border: Border.all(color: black.withOpacity(.1), width: 1)),
      child: Container(
        width: size,
        height: size,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? checkColor : transparent,
        ),
        child: Icon(
          Icons.check,
          size: size <= 16 ? 8 : null,
          color: !selected ? transparent : white,
        ),
      ),
    ),
  );
}

showListDialog(context, List items, onSelected,
    {title, images, bool useTint = true, selections}) {
  pushAndResult(
    context,
    listDialog(
      items,
      title: title,
      images: images,
      useTint: useTint,
      selections: selections,
    ),
    result: (_) {
      if (_ is List) {
        onSelected(_);
      } else {
        onSelected(items.indexOf(_));
      }
    },
  );
}

showSnack(GlobalKey<ScaffoldState> key, String text, {bool useWife = false}) {
  key.currentState
      .showSnackBar(getSnack(key.currentContext, text, useWife: useWife));
}

SnackBar getSnack(context, String text, {bool useWife = false}) {
  return SnackBar(
    content: Text(
      text,
      style: textStyle(true, 16, white),
      textAlign: TextAlign.center,
    ),
    backgroundColor: black,
    duration: Duration(seconds: 2),
  );
}

String getAsset(String name, {String ext = ".png"}) {
  return 'assets/icons/$name$ext';
}

clickLogout(context) async {
  var prefs = await SharedPreferences.getInstance();
  yesNoDialog(context, "Logout?", "Are you sure you want to logout?", () {
    showProgress(true, context, msg: "Logging Out");
    prefs.remove(USER_INFO);
    Future.delayed(Duration(seconds: 2), () {
      showProgress(false, context);
//      pushAndResult(context, LoginPage());
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
      });
    });
  });
}

logMeOut(context) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.remove(USER_INFO);
  Future.delayed(Duration(milliseconds: 500), () {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  });
}

Map<String, String> getHeader() {
  if (userInfo == null) return Map();
  Map<String, String> header = {
//    'Content-Type': 'application/json',
//    'Accept': 'application/json',
    'Authorization': 'Bearer ${userInfo[TOKEN]}',
  };
  return header;
}

titleItem(String title, String text, {textColor = black}) {
  return Container(
    margin: EdgeInsets.only(bottom: 5),
    child: RichText(
      text: TextSpan(children: [
        TextSpan(text: "$title ", style: textStyle(true, 20, red0, love: true)),
        TextSpan(text: "$text", style: textStyle(false, 14, textColor))
      ]),
      textAlign: TextAlign.center,
    ),
  );
}

titleAndTextItem(String title, var text,
    {bool isAmount = false,
    bool center = false,
    color = black,
    bool addSpace = true,
    double titleWidth = 70}) {
  text = text.toString();
  text = text == null ? "" : text;
  text = text == "null" ? "" : text;
  bool negative = text.startsWith("-");
  if (negative) {
    text = text.substring(1);
  }
  if (isAmount && !text.contains(",")) {
    text = formatAmount(text);
  }
  return Container(
//    margin: EdgeInsets.only(bottom: 5),
    child: Column(
      children: <Widget>[
        Row(
//      crossAxisAlignment: center?CrossAxisAlignment.center:CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                width: titleWidth,
                child: Text(
                  title,
                  style: textStyle(false, 12, color.withOpacity(.4)),
                )),
//            addSpaceWidth(8),
//            Container(width: .5,height: 20,color: black.withOpacity(.1),),
            addSpaceWidth(8),
            Flexible(
              child: Row(
                children: <Widget>[
                  if (isAmount)
                    Container(
                        margin: EdgeInsets.only(top: 1.5),
                        child: Image.asset(
                          naira,
                          width: 8,
                          height: 8,
                          color: negative ? red0 : color,
                        )),
                  if (isAmount) addSpaceWidth(2),
                  Flexible(
                      child: Text(
                    text,
                    style: textStyle(true, 12, negative ? red0 : color),
                  )),
                ],
              ),
            )
          ],
        ),
//addSpace(10),
        addLine(.5, black.withOpacity(.1), titleWidth + 7, addSpace ? 8 : 3, 0,
            addSpace ? 8 : 3)
      ],
    ),
  );
}

String formatAmount(var text) {
  if (text == null) return "0.00";
  text = text.toString();
  if (text.isEmpty) return "0.00";
  text = text.replaceAll(",", "");
  try {
    text = double.parse(text).toStringAsFixed(2);
  } catch (e) {}
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  return text.replaceAllMapped(reg, mathFunc);
}

String oldNumber = "";
bool checking = false;
inputTextView(String title, controller,
    {@required isNum,
    @required onEditted,
    int maxLine = 1,
    onTipClicked,
    String errorText,
    double corner = 5,
    bool isAmount = false,
    var icon,
    focusNode}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      if (errorText != null)
        Text(
          errorText,
          style: textStyle(true, 12, red0),
        ),
      if (errorText != null) addSpace(5),
//      addSpace(10),
      Container(
        //height: 45,
        constraints: BoxConstraints(maxHeight: 150),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        decoration: BoxDecoration(
            color: blue09,
            borderRadius: BorderRadius.circular(corner),
            border: Border.all(
                color: errorText != null ? red0 : black.withOpacity(.1),
                width: errorText != null ? 1 : .5)),
        child: Row(
          children: <Widget>[
            if (isAmount || icon != null) addSpaceWidth(10),
            if (isAmount)
              Image.asset(
                naira,
                height: 14,
                width: 14,
                color: black.withOpacity(.3),
              ),
            if (icon != null)
              icon is String
                  ? (Image.asset(
                      naira,
                      height: 14,
                      width: 14,
                      color: black.withOpacity(.3),
                    ))
                  : (Icon(
                      icon,
                      size: 14,
                      color: black.withOpacity(.3),
                    )),
            Flexible(
              child: new TextField(
                onSubmitted: (_) {
                  //postHeadline();
                },
//                textInputAction: maxLine==1?TextInputAction.done:TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(
                      (isAmount || icon != null) ? 10 : 15, 10, 15, 10),
                  counter: null,
                  labelText: title,
                  labelStyle: textStyle(false, 18, black.withOpacity(.3)),
                  /*counterStyle: textStyle(true, 0, white)*/
                ),
                style: textStyle(
                  false,
                  18,
                  black,
                ),
                controller: controller, focusNode: focusNode,
                cursorColor: black,
                cursorWidth: 1,
//                          maxLength: 50,
                maxLines: maxLine > 1 ? null : maxLine,
                keyboardType: isNum
                    ? (TextInputType.number)
                    : maxLine == 1
                        ? TextInputType.text
                        : TextInputType.multiline,
                inputFormatters: [],
                scrollPadding: EdgeInsets.all(0),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

clickText(
  String title,
  String text,
  onClicked, {
  icon,
  double height: 60,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
//      if(text.isNotEmpty)Text(
//        title,
//        style: textStyle(true, 14, dark_green03),
//      ),
//      if(text.isNotEmpty)addSpace(10),
      GestureDetector(
        onTap: () {
          onClicked();
        },
        child: Container(
          height: height,
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          decoration: BoxDecoration(
              color: blue09,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: black.withOpacity(.1), width: .5)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (text.isNotEmpty)
                  Text(
                    title,
                    style: textStyle(false, 12, black.withOpacity(.3)),
                  ),
                Row(
                  children: <Widget>[
                    if (icon != null)
                      Icon(
                        icon,
                        size: 18,
                        color: black.withOpacity(.5),
                      ),
                    if (icon != null) addSpaceWidth(5),
                    Flexible(
                      child: new Text(
                        text.isNotEmpty ? text : title,
                        style: textStyle(false, 18,
                            text.isEmpty ? black.withOpacity(.3) : black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

clickTextShort(String text, onClicked, {icon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      GestureDetector(
        onTap: () {
          onClicked();
        },
        child: Container(
          height: 35,
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
              color: blue09,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: black.withOpacity(.1), width: .5)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                if (icon != null)
                  Icon(
                    icon,
                    size: 14,
                    color: black.withOpacity(.5),
                  ),
                if (icon != null) addSpaceWidth(5),
                new Text(
                  text,
                  style: textStyle(false, 14, black),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

niceButton(double width, text, click,
    {icon, String image = "", bool selected = false, bool tintImage = false}) {
  //bool selected = image != null;
  return new Container(
    width: 80,
    height: 35,
    child: new FlatButton(
        padding: EdgeInsets.all(0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: blue6, width: 1),
            borderRadius: BorderRadius.circular(25)),
        color: selected ? blue6 : transparent,
        onPressed: click,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            addSpaceWidth(10),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Text(
                text,
                style: textStyle(true, 14, selected ? white : blue0),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            addSpaceWidth(5),
            new Container(
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: selected ? transparent : blue0,
                    shape: BoxShape.circle),
                child: Center(
                    child: selected
                        ? Image.asset(
                            image,
                            width: 12,
                            height: 12,
                            color: tintImage ? blue0 : null,
                          )
                        : Icon(
                            icon,
                            color: white,
                            size: 12,
                          ))),
          ],
        )),
  );
}

class ReadMoreText extends StatefulWidget {
  String text;
  bool full;
  var toggle;
  int minLength;
  double fontSize;
  var textColor;
  var moreColor;
  bool center;

  ReadMoreText(this.text,
      {this.full = false,
      this.minLength = 150,
      this.fontSize = 14,
      this.toggle,
      this.textColor = black,
      this.moreColor = blue0,
      this.center = false});

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool expanded;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expanded = widget.full;
  }

  @override
  Widget build(BuildContext context) {
    return text();
  }

  text() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: widget.text.length <= widget.minLength
                  ? widget.text
                  : expanded
                      ? widget.text
                      : (widget.text.substring(0, widget.minLength)),
              style: textStyle(false, widget.fontSize, widget.textColor)),
          TextSpan(
              text: widget.text.length < widget.minLength || expanded
                  ? ""
                  : "...",
              style: textStyle(false, widget.fontSize, black)),
          TextSpan(
            text: widget.text.length < widget.minLength
                ? ""
                : expanded ? " Read Less" : "Read More",
            style: textStyle(true, widget.fontSize - 2, widget.moreColor,
                underlined: false),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                setState(() {
                  expanded = !expanded;
                  if (widget.toggle != null) widget.toggle(expanded);
                });
              },
          )
        ],
      ),
      textAlign: widget.center ? TextAlign.center : TextAlign.left,
    );
  }
}

indexItem(int p, {color: white}) {
  return Container(
    margin: EdgeInsets.only(top: 5),
    width: 30,
    height: 30,
    decoration: BoxDecoration(
        color: color,
        shape: BoxShape
            .circle //,border: Border.all(color: app_blue.withOpacity(.5),width: 1)
        ),
    child: Center(
      child: Text(
        "${p + 1}",
        style: textStyle(false, 16, black.withOpacity(.4)),
      ),
    ),
  );
}

void getApplicationsAPICall(
    context, String url, onComplete(http.Response response, error),
    {Map<String, String> post,
    bool getMethod = false,
    bool putMethod = false,
    bool deleteMethod = false,
    bool patchMethod = false}) async {
  if ((!(await isConnected()))) {
    onComplete(null, "No internet connectivity");
    return;
  }

  post = post == null ? Map() : post;
  bool trustSelfSigned = true;
  HttpClient httpClient = new HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
  IOClient ioClient = new IOClient(httpClient);

  var error;
  if (patchMethod) {
    print("Patch Method - My Map: ${post}");
    final response = await ioClient
        .patch('$url', headers: getHeader(), body: post)
        .catchError((e) {
      error = e;
    });
    if (response == null) {
      onComplete(null, "error occurred");
      return;
    }
    Future.delayed(Duration(milliseconds: 500), () {
      print("Response body >>> ${response.body} <<<");
      var body;
      try {
        body = jsonDecode(response.body);
        if(body.toString().toLowerCase().contains("error"))error = body;
      } catch (e) {}
      if (body != null && body.toString().contains(TOKEN_EXPIRED)
         ||body != null && body.toString().toLowerCase().contains("status: 401")) {
        showMessage(context, Icons.error, red0, "Session Expired!",
            "Your session token has expired, login again.", cancellable: false,
            onClicked: (_) {
          Future.delayed(Duration(milliseconds: 500), () {
            refreshLogin(context, showLoading: true,
            onComplete: (){
              getApplicationsAPICall(context, url, onComplete);
            });
          });
        });
//        onComplete(response, TOKEN_EXPIRED);
        return;
      }
      onComplete(response, error);
    });
  } else if (deleteMethod) {
    print("My Map: ${post}");
    final response = await ioClient
        .delete(
      '$url',
      headers: getHeader(),
    )
        .catchError((e) {
      error = e;
    });
    if (response == null) {
      onComplete(null, "error occurred");
      return;
    }
    Future.delayed(Duration(milliseconds: 500), () {
      print("Response body >>> ${response.body} <<<");
      var body;
      try {
        body = jsonDecode(response.body);
        if(body.toString().toLowerCase().contains("error"))error = body;
      } catch (e) {}
      if (body != null && body.toString().contains(TOKEN_EXPIRED)
          ||body != null && body.toString().toLowerCase().contains("status: 401")) {
        showMessage(context, Icons.error, red0, "Session Expired!",
            "Your session token has expired, login again.", cancellable: false,
            onClicked: (_) {
          Future.delayed(Duration(milliseconds: 500), () {
            refreshLogin(context, showLoading: true,
                onComplete: (){
                  getApplicationsAPICall(context, url, onComplete);
                });
          });
        });
//        onComplete(response, TOKEN_EXPIRED);
        return;
      }
      onComplete(response, error);
    });
  } else if (putMethod) {
    print("My Map: ${post}");
    final response = await ioClient
        .put('$url', headers: getHeader(), body: post)
        .catchError((e) {
      error = e;
    });
    if (response == null) {
      onComplete(null, "error occurred");
      return;
    }
    Future.delayed(Duration(milliseconds: 500), () {
      print("Response body >>> ${response.body} <<<");
      var body;
      try {
        body = jsonDecode(response.body);
        if(body.toString().toLowerCase().contains("error"))error = body;
      } catch (e) {}
      if (body != null && body.toString().contains(TOKEN_EXPIRED)
          ||body != null && body.toString().toLowerCase().contains("status: 401")) {
        showMessage(context, Icons.error, red0, "Session Expired!",
            "Your session token has expired, login again.", cancellable: false,
            onClicked: (_) {
          Future.delayed(Duration(milliseconds: 500), () {
            refreshLogin(context, showLoading: true,
                onComplete: (){
                  getApplicationsAPICall(context, url, onComplete);
                });
          });
        });
//        onComplete(response, TOKEN_EXPIRED);
        return;
      }
      onComplete(response, error);
    });
  } else if (getMethod) {
    post[HttpHeaders.contentTypeHeader] = 'application/json';
    post[HttpHeaders.authorizationHeader] = "Bearer ${userInfo[TOKEN]}";
    print("My Map: ${post}");
    final response = await ioClient.get('$url', headers: post).catchError((e) {
      error = e;
    });
    if (response == null) {
      onComplete(null, "error occurred");
      return;
    }
    Future.delayed(Duration(milliseconds: 500), () {
      print("Response body >>> ${response.body} <<<");
      var body = jsonDecode(response.body);
      if(body.toString().toLowerCase().contains("error"))error = body;
      if (body.toString().contains(TOKEN_EXPIRED)
          ||body != null && body.toString().toLowerCase().contains("status: 401")) {
        showMessage(context, Icons.error, red0, "Session Expired!",
            "Your session token has expired, login again.", onClicked: (_) {
          Future.delayed(Duration(milliseconds: 500), () {
            refreshLogin(context, showLoading: true,
                onComplete: (){
                  getApplicationsAPICall(context, url, onComplete);
                });
          });
        });
//        onComplete(response, TOKEN_EXPIRED);
        return;
      }
      onComplete(response, error);
    });
  } else {
    print("My Map: ${post}");
    final response = await ioClient
        .post('$url', headers: getHeader(), body: post)
        .catchError((e) {
      error = e;
    });
    if (response == null) {
      onComplete(null, "error occurred");
      return;
    }
    Future.delayed(Duration(milliseconds: 500), () {
      print("Response body >>> ${response.body} <<<");
      var body;
      try {
        body = jsonDecode(response.body);
        if(body.toString().toLowerCase().contains("error"))error = body;
      } catch (e) {}
      if (body != null && body.toString().contains(TOKEN_EXPIRED)
          ||body != null && body.toString().toLowerCase().contains("status: 401")) {
        showMessage(context, Icons.error, red0, "Session Expired!",
            "Your session token has expired, login again.", cancellable: false,
            onClicked: (_) {
          Future.delayed(Duration(milliseconds: 500), () {
            refreshLogin(context, showLoading: true,
                onComplete: (){
                  getApplicationsAPICall(context, url, onComplete);
                });
          });
        });
//        onComplete(response, TOKEN_EXPIRED);
        return;
      }
      onComplete(response, error);
    });
  }
}

void getApplicationsAPICallWithFile(
    context, String url, onComplete(dioLib.Response response, error),
    {Map<String, dynamic> post,
    bool getMethod = false,
    bool putMethod = false,
    bool deleteMethod = false,
    bool patchMethod = false}) async {
  if ((!(await isConnected()))) {
    onComplete(null, "No internet connectivity");
    return;
  }
  try {
    var form = dioLib.FormData.fromMap(post);
    print("Requesting $url");
    dioLib.Dio dio = dioLib.Dio();
    dio.interceptors.add(
        dioLib.InterceptorsWrapper(onRequest: (dioLib.RequestOptions options) {
      // Do something before request is sent
      options.headers["Authorization"] = "Bearer " + userInfo[TOKEN];
      return options;
    }));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    var res = putMethod
        ? (await dio.put(
            url,
            data: form,
          ))
        : getMethod
            ? (await dio.get(
                url,
              ))
            : patchMethod
                ? (await dio.patch(
                    url,
                    data: form,
                  ))
                : await dio.post(
                    url,
                    data: form,
                  );
    print("response>>: ${res.data}");
    if (res == null) {
      onComplete(null, "error occurred");
      return;
    }
    Future.delayed(Duration(milliseconds: 500), () {
      print("Response body >>> ${res.data} <<<");
      var body;
      try {
        body = jsonDecode(res.data);
//        if(body.toString().toLowerCase().contains("error"))error = body;
      } catch (e) {}
      if (body != null && body.toString().contains(TOKEN_EXPIRED)
          ||body != null && body.toString().toLowerCase().contains("status: 401")) {
        showMessage(context, Icons.error, red0, "Session Expired!",
            "Your session token has expired, login again.", cancellable: false,
            onClicked: (_) {
          Future.delayed(Duration(milliseconds: 500), () {
            refreshLogin(context, showLoading: true,
                onComplete: (){
                  getApplicationsAPICallWithFile(context, url, onComplete);
                });
          });
        });
//        onComplete(res, TOKEN_EXPIRED);
        return;
      }
      onComplete(res, null);
    });
  } catch (e) {
    if (e.toString().contains("401")) {
      showMessage(context, Icons.error, red0, "Session Expired!",
          "Your session token has expired, login again.", cancellable: false,
          onClicked: (_) {
        Future.delayed(Duration(milliseconds: 500), () {
          refreshLogin(context, showLoading: true);
        });
      });
    } else {}
    onComplete(null, e.toString());
//    print("Exception Caught: $e");
  }
}

bool logging = false;
refreshLogin(context, {bool showLoading = false, onComplete}) async {
  if (!(await isConnected())) return;
  if (logging) return;
  logging = true;
  var pref = await SharedPreferences.getInstance();
  String email = pref.getString(EMAIL);
  String password = pref.getString(PASSWORD);

  var url = BASE_API + "auth/login";
  if (showLoading) showProgress(true, context, msg: "Refreshing Login");
  getApplicationsAPICall(
    context,
    url,
    (response, error) async {
      logging = false;
      if (showLoading) showProgress(false, context);
      if (error != null) {
        //refreshLogin(context);
        return;
      }
      String body = response.body;
      print(body);
      Map responseBody = jsonDecode(body);
      print("Logged In: $responseBody");
      if (!body.toString().toLowerCase().contains("error")) {
        var pref = await SharedPreferences.getInstance();
        String json = jsonEncode(body);
        Map map = jsonDecode(body);
        pref.setString(USER_INFO, json);
        pref.setString(USER_INFO_BACKUP, json);
        pref.setString(EMAIL, email);
        pref.setString(PASSWORD, password);
        userInfo = map;

        if (onComplete != null) onComplete();
      }
    },
    post: {'email': email, 'password': password},
  );
}

pickCountry(context, onPicked(Country country)) {
  pushAndResult(context, countryDialog(), result: (_) {
    onPicked(_);
  });
}

/*checkResponse(context, String body) {
  if (body.toString().contains(TOKEN_EXPIRED)) {
    showMessage(context, Icons.error, red0, "Session Expired!",
        "Your session token has expired, login again.", cancellable: false,
        onClicked: (_) {
      Future.delayed(Duration(milliseconds: 500), () {
        refreshLogin(context, showLoading: true);
      });
    });
    return;
  }
}*/

List getListFromMap(String key, List list) {
  List items = [];
  for (Map map in list) {
    var item = map[key];
    if (item == null || (item is String && item.toString().isEmpty)) continue;
    items.add(map[key]);
  }
  return items;
}

getItemFromMap(value, String itemKey, List list) {
  for (Map map in list) {
    if (map.containsValue(value)) {
      return map[itemKey];
    }
  }
  return null;
}

handleError(context, error) {
  showMessage(context, Icons.error, red0, "Error!", error.toString(),
      delayInMilli: 500);
}

String getFullName() {
  if(userInfo==null)return "";
  if(userInfo["data"]==null)return "";
  return "${userInfo["data"]["firstName"]} ${userInfo["data"]["lastName"]}";
}

String getFirstName() {
  if(userInfo==null)return "";
  if(userInfo["data"]==null)return "";
  return "${userInfo["data"]["firstName"]}";
}

