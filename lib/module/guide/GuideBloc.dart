import 'package:app/packages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class GuideBloc extends BlocBase with LoggingMixin {
  GuideBloc(BuildContext context, Store store) : super(context, store);
  String loading = "##loading##";
  static const loadingTag = "##loading##"; //表尾标记
  var words = <String>[loadingTag];
  List textList = ["体验美好生活", "连接智能设备", "让爱更有温度", "守护你的健康"];
  bool show = false;
  String text = "最新";
  double w = 0;

  void startup() {
    //retrieveData();
    log.info("w222222222222222");
  }

  void to() {
    navigate.pushReplacementNamed('/login');
    //navigate.pushReplacementNamed('/homeCon');
  }

  void click(int i) {
    navigate.pushReplacementNamed('/homeCon');
  }

  void retrieveData() {
    Future.delayed(Duration(seconds: 0)).then((e) {
      words.insertAll(
          words.length - 1,
          //每次生成20个单词
          ["1", "2", "3", "4", "5", "6", "7"].map((e) => e).toList());
      setModel(() {});
//      setState(() {
//        //重新构建列表
//      });
    });
  }
}
