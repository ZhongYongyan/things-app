import 'package:app/packages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class MsgBloc extends BlocBase with LoggingMixin {
  MsgBloc(BuildContext context, Store store) : super(context, store);
  String loading = "##loading##";
  static const loadingTag = "##loading##"; //表尾标记
  var words = <String>[loadingTag];
  List textList = ["最新", "健康饮食", "运动减肥"];
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

  }

  void click(int i) {
    log.info(i);
    navigate.pushNamed('/msgDetails');
    //navigate.pushReplacementNamed('/homeCon');
  }

  void retrieveData() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      words.insertAll(
          words.length - 1,
          //每次生成20个单词
          ["1", "2", "3", "4", "5"]
              .map((e) => e)
              .toList());
      setModel(() {});
//      setState(() {
//        //重新构建列表
//      });
    });
  }
}
