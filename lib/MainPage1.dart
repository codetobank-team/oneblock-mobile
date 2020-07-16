import 'dart:convert';

import 'package:Oneblock/AppEngine.dart';
import 'package:Oneblock/Details.dart';
import 'package:Oneblock/ReceiveMoney.dart';
import 'package:Oneblock/SendMoney.dart';
import 'package:Oneblock/assets.dart';
import 'package:flutter/material.dart';

class MainPage1 extends StatefulWidget {
  @override
  _MainPage1State createState() => _MainPage1State();
}
/*{status: 200, data: {balance: 0.00, userId: 5f0fa16599d5bb001ee8dcd8,
accountNumber: 7461363807, address: 0x663Ff687C051f12516337f38004F11dBd08D5f93, createdAt: 2020-07-16T00:37:58.410Z,
 updatedAt: 2020-07-16T00:37:58.410Z, id: 5f0fa16699d5bb001ee8dcd9}}*/
class _MainPage1State extends State<MainPage1> with AutomaticKeepAliveClientMixin {
  List transactions = [];
  bool setup = false;
  bool refreshingBalance = false;
  bool transLoading = false;
  Map accountDetails;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadItems();
  }

  loadItems({bool silently=false})async{
    getApplicationsAPICall(context, BASE_API + "user/wallet/", (res,error){
      if(error!=null){
        showMessage(context, Icons.error, red0, "Error", error.toString(),
            onClicked: (_){
              if(_==true){
                loadItems();
              }else{
                setup=true;
                setState(() {

                });
              }
            },clickYesText: "Retry");
//        return;
      }
      var body = jsonDecode(res.body);
      print(body);
      accountDetails=body["data"];
      setup=true;
      refreshingBalance=false;
      if(mounted)setState(() {});
      loadTrans(silently: silently);
    },getMethod: true,
//        post: {"transactionPin":"1111"}
    );
  }

  loadTrans({bool silently=false}) async {
    if(!silently) {
      transLoading = true;
      setState(() {});
    }
    String url= BASE_API + "transactions";
    print("Loading Transactions from $url");
    getApplicationsAPICall(context, url, (res,error){
      if(error!=null){
        if(error.toString().contains("Transaction")){
          transLoading=false;
          if(mounted)setState(() {});
          return;
        }
        if(!silently)showMessage(context, Icons.error, red0, "Error", error.toString(),
            onClicked: (_){
              if(_==true){
                loadItems();
              }else{
                transLoading=false;
                setState(() {

                });
              }
            },clickYesText: "Retry");
        return;
      }
      var body = jsonDecode(res.body);
      print("Trans $body");
      List trans=body["data"];
      transactions= List.from(trans.reversed);
      transLoading=false;
      if(mounted)setState(() {});
    },getMethod: true,
//        post: {"transactionPin":"1111"}
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: !setup?loadingLayout():page(),
      backgroundColor: default_white,
    );
  }

  page() {
    return Column(
      children: [
        addSpace(50),
        Row(
          children: [
            addSpaceWidth(15),
            imageHolder(50, "",),
            addSpaceWidth(10),
            Text("Hello ${getFirstName()}", style: textStyle(true, 18, black)),
            addSpaceWidth(20),
          ],
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15,15,15,10),
          child: Card(
            elevation: 5,
            clipBehavior: Clip.antiAlias,color: app_red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15,15,15,15),
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet, size: 40, color: white),
                  addSpaceWidth(15),
                  Flexible(fit:FlexFit.tight,
                                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Available Balance",
                          style: textStyle(false, 16, white),
                        ),
                        addSpace(5),
                        if (!refreshingBalance)
                          Row(
                            children: [
                              Image.asset(naira, width: 16, height: 15, color: white),
                              addSpaceWidth(5),
                              Flexible(
                                child: Text(
                                  formatAmount(accountDetails["balance"]),
                                  style: textStyle(true, 20, white),
                                ),
                              ),
                              addSpaceWidth(5),
                              GestureDetector(
                                onTap: (){
                                  refreshingBalance=true;
                                  setState(() {

                                  });
                                  loadItems(silently: true);
                                },
                                child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(color: red6,shape: BoxShape.circle)
                                ,child: Icon(Icons.refresh,color: white,size: 14,)),
                              )
                            ],
                          ),
                        if (refreshingBalance)
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                  color: red4,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Row(
    mainAxisSize: MainAxisSize.min,children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    //value: 20,
                                    valueColor: AlwaysStoppedAnimation<Color>(white),
                                    strokeWidth: 2,
                                  ),
                                ),
                                addSpaceWidth(10),
                                Text(
                                  "Refreshing",
                                  style: textStyle(true, 12, white),
                                )
                              ]))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  height: 40,
                  child: FlatButton(
                    onPressed: () {
                      pushAndResult(context, SendMoney(),result: (_){
                        refreshingBalance=true;
                        transLoading=true;
                        setState(() {

                        });
                        loadItems();
                      });
                    },
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      Icon(Icons.send, color: white,size: 17,),
                      addSpaceWidth(8),
                      Text(
                        "Send",
                        style: textStyle(true, 16, white),
                      )
                    ]),
                    color: black.withOpacity(.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),//side: BorderSide(color: black.withOpacity(.5),width: 1)
                    ),
                  ),
                ),
              ),
              addSpaceWidth(10),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  height: 40,
                  child: FlatButton(
                    onPressed: () {
                      pushAndResult(context,ReceiveMoney("${accountDetails["address"]}"));
                    },
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_downward, color: blue0,size: 18,),
                          addSpaceWidth(8),
                          Text(
                            "Receive",
                            style: textStyle(true, 16, blue0),
                          )
                        ]),
                    color: white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),side: BorderSide(color: black.withOpacity(.1),width: .5)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
         Expanded(
             child: Container(
           margin: EdgeInsets.fromLTRB(15, 0, 15, 15),width: double.infinity,
           decoration: BoxDecoration(
               color: white, borderRadius: BorderRadius.circular(10)),
           child: transLoading?loadingLayout():transactions.isEmpty?
           emptyLayout(Icons.monetization_on, "No Transactions Yet", "",clickText: "Refresh",click: (){
             loadTrans();
           }):Padding(
             padding: const EdgeInsets.fromLTRB(20,0,20,0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 addSpace(10),
                 Row(
                   children: [
                     Flexible(fit: FlexFit.tight,
                       child: Text(
                         "Recent Transactions",
                         style: textStyle(true, 14, black),
                       ),
                     ),
                     GestureDetector(
                       onTap: (){
                         loadTrans();
                       },
                       child: Container(
//                           padding: EdgeInsets.all(5),
//                           decoration: BoxDecoration(color: red6,shape: BoxShape.circle),
                           child: Icon(Icons.refresh,color: black.withOpacity(.5),size: 18,)),
                     )
                   ],
                 ),
                 addSpace(20),
                  Expanded(
                    child: !setup
                        ? loadingLayout()
                        : ListView.builder(
                            itemBuilder: (c, p) {
                              return transItem(p);
                            },
                            itemCount: transactions.length,padding: EdgeInsets.all(0),
                          ),
                  ),
               ],
             ),
           ),
         )
         )
       ],
    );
  }

  transItem(int p) {
    /*
    * {status: completed, blockchainTimestamp: 1594880277637,
    * sender: 0x7fff8d4A4ec32BEbFf43B9316d4BE8369d805858,
    * recipient: 0x663Ff687C051f12516337f38004F11dBd08D5f93,
    * hash: 56ce6e75e3ed7a4fe569fa6b3661a9b80a856bd4b4d9f8b775265e9cdb7427b7,
    * amount: 400, createdAt: 2020-07-16T06:17:57.643Z,
    * updatedAt: 2020-07-16T06:17:57.643Z, id: 5f0ff115ae1752001d99ce8d, type: sent}*/
    Map item = transactions[p];
    bool incoming = item["type"]!="sent";
    String recipient = item["recipient"]??"";
    String sender = item["sender"]??"";
    String amount = formatAmount(item["amount"]);
    int time = item["blockchainTimestamp"];
    var color = incoming ? blue0 : black.withOpacity(.5);
    return GestureDetector(
      onTap: (){
        pushAndResult(context, Details(item));
      },
      child: Container(color: transparent,
        child: Column(
          children: [
            Container(
              height: 70,
              child: Row(
                children: [
                  Container(width: 20,height: 20,
                    decoration: BoxDecoration(
                      color: color,
//                  border: Border.all(color:color,width: 1),
                        shape: BoxShape.circle
                    ),
                    child: Icon(
                      incoming ? Icons.arrow_downward : Icons.arrow_upward,size: 14,
                      color: white,
                    ),
                  ),
                  addSpaceWidth(10),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          incoming ? "Received" : "Sent",
                          style: textStyle(false, 16, black),
                        ),
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
                      ],
                    ),
                  ),
                  Image.asset(
                    naira,
                    width: 12,
                    height: 12,
                    color: color,
                  ),
                  addSpace(5),
                  Text(
                    amount,
                    style: textStyle(true, 17, color),
                  )
                ],
              ),
            ),
            addLine(.5, black.withOpacity(.1), 0, 0, 0, 0)
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
