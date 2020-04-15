import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/store/module/Auth.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class MyBloc extends BlocBase with LoggingMixin {
  MyBloc(BuildContext context, Store store) : super(context, store);
  String loading = "##loading##";
  static const loadingTag = "##loading##"; //表尾标记
  var words = <String>[loadingTag];
  List textList = [
    "你好",
    "京东商城",
    "天猫商城",
    "版本更新",
    "语言选择",
    "官方声明",
    "APP使用说明",
    "插件"
  ];
  bool show = false;
  String text = "最新";
  double h = 0;

  void startup() {
    //retrieveData();
    log.info("我的");
  }

  void signout() {
    dispatch(authActions.logout());
    navigate.pushReplacementNamed('/login');
  }

  void to(String t) {
    setModel(() {
      text = t;
    });
    log.info(text);
    //navigate.pushReplacementNamed('/homeCon');
  }

  void click(int i) async {
    if (i == 1) {
      const url = 'https://www.jd.com';

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    if (i == 2) {
      const url = 'https://www.tmall.com';

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

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
