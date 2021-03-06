import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomActionSheet {
  static show(BuildContext context, List<String> data,
      {String title: '',cancel:'', Function callBack(int)}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Color.fromRGBO(114, 114, 114, 1),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //为了防止控件溢出
                  Flexible(
                      child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(Radius.circular(14)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        title != ""
                            ? new Container(
                                height: 60,
                                alignment: Alignment.center,
                                child: new Text(
                                  title,
                                  style: TextStyle(
                                    color: Color(0xFFB6B8BF),
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(),
                        title != ""
                            ? Divider(
                                height: 1,
                                color: Color(0xFFF3F3F3),
                              )
                            : Container(),
                        Flexible(
                            child: ListView.builder(
                          /**
                                      If you do not set the shrinkWrap property, your ListView will be as big as its parent.
                                      If you set it to true, the list will wrap its content and be as big as it children allows it to be. */
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                new ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    callBack(index);
                                  },
                                  title: new Text(
                                    data[index],
                                    style: TextStyle(
                                      color: title != ""
                                          ? Color(0xFFF97188)
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                index == data.length - 1
                                    ? Container()
                                    : Divider(
                                        height: 1,
                                        color: Color(0xFFA2A2A6),
                                      ),
                              ],
                            );
                          },
                        )),
                      ],
                    ),
                  )),
                  SizedBox(
                    height: 9,
                  ),
                  GestureDetector(
                    onTap: () {
                      //点击取消 弹层消失
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 56,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.all(Radius.circular(14)),
                      ),
                      child: Text(cancel,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            color: Color(0xFF007AFF),
                            fontSize: 17.0,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
