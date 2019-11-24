import 'package:app/packages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class datailsBloc extends BlocBase with LoggingMixin {
  datailsBloc(BuildContext context, Store store) : super(context, store);
  String loading = "##loading##";
  static const loadingTag = "##loading##"; //表尾标记
  var words = <String>[loadingTag];
  List textList = ["你好", "京东商城", "天猫商城", "版本更新", "语言选择", "官方声明", "APP使用说明"];
  var list = [
    "基本信息",
    "睡眠情况",
    "血压",
    "心率",
    "情绪",
    "血流",
    "呼吸",
  ];
  bool show = false;
  String text = "最新";

  void startup() {
    //retrieveData();
    log.info("w222222222222222");
  }

  void to(String t) {
    setModel(() {
      text = t;
    });
    log.info(text);
    //navigate.pushReplacementNamed('/homeCon');
  }

  void click(int i) {
    log.info(i);
    //navigate.pushReplacementNamed('/homeCon');
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
