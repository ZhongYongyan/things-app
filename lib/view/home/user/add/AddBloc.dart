import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class AddBloc extends BlocBase with LoggingMixin {
  AddBloc(BuildContext context, Store store) : super(context, store);
  String loading = "##loading##";
  static const loadingTag = "##loading##"; //表尾标记
  var words = <String>[loadingTag];
  List textList = ["你好", "京东商城", "天猫商城", "版本更新", "语言选择", "官方声明", "APP使用说明"];
  bool show = false;
  String text = "最新";

  void startup() {

  }

  void to(String t) {
    setModel(() {
      text = t;
    });
  }

  void click(int i) {

  }

  void back() {
    navigate.pop();
  }

  void retrieveData() {
    Future.delayed(Duration(seconds: 0)).then((e) {
      words.insertAll(
          words.length - 1,
          //每次生成20个单词
          ["1", "2", "3", "4", "5", "6", "7"].map((e) => e).toList());
      setModel(() {});
    });
  }
}
