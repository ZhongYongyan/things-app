import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class MainBloc extends BlocBase with LoggingMixin {
  MainBloc(BuildContext context, Store store) : super(context, store);
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController tabController;
  int index = 0;
  List item = [
    "基本信息",
    "睡眠情况",
    "血压",
    "心率",
    "情绪",
    "血流",
    "呼吸",
  ];
  bool show = false;

  void startup() {
    tabController.addListener(() {
      setModel(() {
        index = tabController.index;
      });
      print(tabController.index);
    });
  }

  void to() {
    navigate.pushNamed('/user');
  }
}
