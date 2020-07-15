import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Oneblock/AppEngine.dart';
import 'package:Oneblock/Assets.dart';

class listDialog extends StatefulWidget {
  String title;
  var items;
  List images;
  bool useTint;
  List selections;

  listDialog(items,
      {title, images, bool useTint = true,selections}) {
    this.title = title;
    this.items = items;
    this.images = images == null ? List() : images;
    this.useTint = useTint;
    this.selections = selections;
  }

  @override
  _listDialogState createState() => _listDialogState();
}

class _listDialogState extends State<listDialog> {
  BuildContext context;

  List selections = [];
  bool multiple;

  bool setup = false;
  bool showCancel = false;
  FocusNode focusSearch = FocusNode();
  TextEditingController searchController = TextEditingController();
  List listItems=[];
  List allItems=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    multiple = widget.selections !=null;
    selections = widget.selections??[];
    allItems = widget.items;
    reload();
    if(allItems.isEmpty){
      Future.delayed(Duration(milliseconds: 500),(){
        Navigator.pop(context);
        showMessage(context, Icons.error, red0, "Empty", "Nothing to display");
      });
    }
  }

  reload(){
    String search = searchController.text.trim();
    listItems.clear();
    for(String s in allItems){
      if(search.isNotEmpty && !s.toLowerCase().contains(search.toLowerCase()))continue;
      listItems.add(s);
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(backgroundColor: transparent,
      body: Stack(fit: StackFit.expand, children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: black.withOpacity(.7),
              )),
        ),
        page()
      ]),
    );
  }

  page() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 45, 25, 25),
        child: new Container(
          decoration: BoxDecoration(
              color: white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  width: double.infinity,
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      addSpaceWidth(15),
                      Image.asset(
                        ic_plain,
                        height: 14,
                        width: 14,
                      ),
                      addSpaceWidth(10),
                      new Flexible(
                        flex: 1,
                        child: widget.title == null
                            ? new Text(
                                "Oneblock",
                                style:
                                    textStyle(false, 11, black.withOpacity(.1)),
                              )
                            : new Text(
                                widget.title,
                                style: textStyle(true, 20, black),
                              ),
                      ),
                      addSpaceWidth(15),
                    ],
                  ),
                ),
                addSpace(5),
                if(allItems.length>3)Container(
                  height: 45,
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: BoxDecoration(
                      color: white.withOpacity(.8),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: app_blue.withOpacity(.5),width: 1)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      addSpaceWidth(10),
                      Icon(
                        Icons.search,
                        color: app_blue.withOpacity(.5),
                        size: 17,
                      ),
                      addSpaceWidth(10),
                      new Flexible(
                        flex: 1,
                        child: new TextField(
                          textInputAction: TextInputAction.search,
                          textCapitalization: TextCapitalization.sentences,
                          autofocus: false,
                          onSubmitted: (_) {
                            //reload();
                          },
                          decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: textStyle(
                                false,
                                18,
                                blue3.withOpacity(.5),
                              ),
                              border: InputBorder.none,isDense: true),
                          style: textStyle(false, 16, black),
                          controller: searchController,
                          cursorColor: black,
                          cursorWidth: 1,
                          focusNode: focusSearch,
                          keyboardType: TextInputType.text,
                          onChanged: (s) {
                            showCancel = s.trim().isNotEmpty;
                            setState(() {});
                            reload();
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            focusSearch.unfocus();
                            showCancel = false;
                            searchController.text = "";
                          });
                          reload();
                        },
                        child: showCancel
                            ? Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: Icon(
                            Icons.close,
                            color: black,
                            size: 20,
                          ),
                        )
                            : new Container(),
                      )
                    ],
                  ),
                ),
                addLine(.5, black.withOpacity(.1), 0, 0, 0, 0),
                Flexible(
                  child: Container(
                    color: white,
                    child: new ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: (MediaQuery.of(context).size.height / 2) +
                              (MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? 0
                                  : (MediaQuery.of(context).size.height / 5))),
                      child: Scrollbar(
                        child: new ListView.builder(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          itemBuilder: (context, position) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                position == 0
                                    ? Container()
                                    : addLine(
                                        .5, black.withOpacity(.1), 0, 0, 0, 0),
                                GestureDetector(
                                  onTap: () {
                                    if(multiple){
                                      bool selected = selections.contains(listItems[position]);
                                      if(selected){
                                        selections.remove(listItems[position]);
                                      }else{
                                        selections.add(listItems[position]);
                                      }
                                      setState(() {

                                      });
                                      return;
                                    }
                                    Navigator.of(context).pop(listItems[position]);
                                  },
                                  child: new Container(
                                    color: white,
                                    width: double.infinity,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          widget.images.isEmpty
                                              ? Container()
                                              : !(widget.images[position] is String)
                                                  ? Icon(
                                                      widget.images[position],
                                                      size: 17,
                                                      color: !widget.useTint
                                                          ? null
                                                          : black.withOpacity(.3),
                                                    )
                                                  : Image.asset(
                                                      widget.images[position],
                                                      width: 17,
                                                      height: 17,
                                                      color: !widget.useTint
                                                          ? null
                                                          : black.withOpacity(.3),
                                                    ),
                                          widget.images.isNotEmpty
                                              ? addSpaceWidth(10)
                                              : Container(),
                                          Flexible(
                                            flex:1,fit:FlexFit.tight,
                                            child: Text(
                                              listItems[position]??"",
                                              style: textStyle(
                                                  false, 18, black.withOpacity(.8)),
                                            ),
                                          ),
                                          if(multiple)addSpace(10),
                                          if(multiple)checkBox(selections.contains(listItems[position]))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: listItems.length,
                          shrinkWrap: true,
                        ),
                      ),
                    ),
                  ),
                ),
                addLine(.5, black.withOpacity(.1), 0, 0, 0, 0),
                if (multiple)
                  Container(
                      width: double.infinity,
                      height: 40,
                      margin: EdgeInsets.all(10),
                      child: FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(side: BorderSide(color: blue0,width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          color: white,
                          onPressed: () {
                            /*if(selections.isEmpty){
                              toastInAndroid("Nothing Selected");
                              return;
                            }*/
                            Navigator.pop(context, selections);
                          },
                          child: Text(
                            "OK",
                            style: textStyle(true, 16, blue0),
                          )))
                //gradientLine(alpha: .1)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
