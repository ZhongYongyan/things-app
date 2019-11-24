import 'package:app/packages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class UsercomBloc extends BlocBase with LoggingMixin {
  UsercomBloc(BuildContext context, Store store) : super(context, store);
  final TextEditingController usernameController =
      TextEditingController(text: '');
  String loading = "##loading##";
  static const loadingTag = "##loading##"; //表尾标记
  var words = <String>[loadingTag];
  List textList = ["修改头像", "姓名或昵称", "性别", "身高(cm)", "体重(kg)", "出生日期"];
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
          ["1", "2", "3", "4", "5", "6"].map((e) => e).toList());
      setModel(() {});
//      setState(() {
//        //重新构建列表
//      });
    });
  }
}
