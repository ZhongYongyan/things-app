import 'package:app/packages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class ManagementBloc extends BlocBase with LoggingMixin {
  ManagementBloc(BuildContext context, Store store) : super(context, store);
  var textList = [
    "按摩椅",
    "健康饮食",
    "运动减肥",
  ];

  var text = "按摩椅";
  void back(){
    navigate.pop();
  }
  void startup() {
    //retrieveData();
    log.info("我是详情");
  }
  void to() {

  }
}
