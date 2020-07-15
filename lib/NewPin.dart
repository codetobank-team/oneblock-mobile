import 'package:Oneblock/AppEngine.dart';
import 'package:Oneblock/assets.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class NewPin extends StatefulWidget {
  String defPin;
  NewPin({this.defPin = ""});
  @override
  _NewPinState createState() => _NewPinState();
}

class _NewPinState extends State<NewPin> {
  TextEditingController pinController = TextEditingController();

  String defPin;

  @override
  void initState() {
    defPin = widget.defPin;
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
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  addSpace(20),
                  Text(
                    "${defPin.isEmpty ? "Setup" : "Confirm"} Pin",
                    style: textStyle(false, 40, app_red),
                  ),
                  Text(
                    defPin.isEmpty?"Secure your transactions with a pin you can remember":
                    "Retype your transaction pin",
                    style: textStyle(false, 14, black),
                  ),
                  addSpace(20),
                  PinCodeTextField(
                    length: 4,
                    obsecureText: false,
                    animationType: AnimationType.fade,
                    textInputType: TextInputType.number,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 40,
                        fieldWidth: 40,
                        inactiveFillColor: white,
                        disabledColor: black.withOpacity(.02),
                        inactiveColor: black.withOpacity(.1),
                        selectedColor: black.withOpacity(.02),
                        activeFillColor: black.withOpacity(.02),
                        activeColor: black.withOpacity(.02),
                        selectedFillColor: red0),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: transparent,
                    enableActiveFill: true,
                    controller: pinController,
                    onCompleted: (v) {},
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      return true;
                    },
                  ),

                  addSpace(15),

                  Container(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        String pin = pinController.text.trim();
                        if (pin.length < 4) {
                          showError("Enter a 4 digit pin");
                          return;
                        }
                        if (defPin.isNotEmpty && defPin != pin) {
                          showError("Pin does not match");
                          return;
                        }

                        Navigator.pop(context, pin);
                      },
                      color: app_red,
                      textColor: white,
                      child: Text(
                        "OK",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "NirmalaB",
                            fontWeight: FontWeight.normal,
                            color: white),
                      ),
                      elevation: .5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  addSpace(20),
//              addSpace(100)
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
