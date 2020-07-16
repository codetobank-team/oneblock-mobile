import 'package:Oneblock/AppEngine.dart';
import 'package:Oneblock/ShakeWidget.dart';
import 'package:Oneblock/assets.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterPin extends StatefulWidget {

  @override
  _EnterPinState createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  TextEditingController pinController = TextEditingController();
  List pins = [];
  int shakeKey = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: page(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pinController?.dispose();
  }

  page() {
    return Column(
      children: [
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

//        addSpace(20),

        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Enter Your Transaction Pin",
                    style: textStyle(false, 20, black),
                  ),

                  addSpace(10),
                  Center(
                      child:ShakeWidget(key: Key("$shakeKey"),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(4, (index){

                            return Container(
                              width: 20,height:20,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: pins.length>index?app_red:white,shape: BoxShape.circle,
                                  border: Border.all(
                                      color: app_red,width: 2
                                  )
                              ),
                            );
                          }),
                        ),
                      )
                  ),
                  addSpace(5),
                  GestureDetector(
                    onTap: () {
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
addSpace(10),
Wrap(crossAxisAlignment: WrapCrossAlignment.center,alignment: WrapAlignment.center,
  children: List.generate(11, (p){

    String text = "${p+1}";
    text = p==9?"0":text;
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.all(5),
      child: RaisedButton(onPressed: (){
        if(p==10){
          if(pins.isNotEmpty)pins.removeLast();
          print("Removed");
        }else {
          if(pins.length<4)pins.add(text);
        }
        setState(() {});
        if(pins.length==4){
          StringBuffer pinBuilder = StringBuffer();
          for(String s in pins){
            pinBuilder.write(s);
          }
          Navigator.pop(context,pinBuilder.toString());
         /* Future.delayed(Duration(milliseconds: 300),()async{
            SharedPreferences shed = await SharedPreferences.getInstance();
            String myPin = shed.getString(PIN)??"";
            StringBuffer pinBuilder = StringBuffer();
            for(String s in pins){
              pinBuilder.write(s);
            }
            if(myPin!=pinBuilder.toString()) {
              showError("Incorrect Pin");
              pins.clear();
              shakeKey++;
              setState(() {});
            }else{
              Navigator.pop(context,pinBuilder.toString());
            }
          });*/
        }
      },elevation: 1,
        color: app_red,shape: CircleBorder(),
        child: p==10?Icon(Icons.backspace,color: white,size: 18,):Text("$text",style: textStyle(true, 20, white
        ),),
      ),
    );
  }),
)
                 /* GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,crossAxisSpacing: 10,mainAxisSpacing: 10,
                    crossAxisCount: 3,
                  ),padding: EdgeInsets.all(0),shrinkWrap: true,
                    itemBuilder: (c,p){

                    String text = "${p+1}";
                    text = p==9?"0":text;
                    return Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.all(5),
                      child: RaisedButton(onPressed: (){

                      },elevation: 1,
                        color: app_red,shape: CircleBorder(),
                      child: p==10?Icon(Icons.backspace,color: white,size: 18,):Text("$text",style: textStyle(true, 20, white
                      ),),
                      ),
                    );
                  },itemCount: 11,),*/
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
      SharedPreferences shed = await SharedPreferences.getInstance();
      String myPin = shed.getString(PIN)??"";
      Navigator.pop(context,myPin);
//      startLogin(myEmail, myPass);
    }
  }

}
