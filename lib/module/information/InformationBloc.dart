import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'dart:async';
import 'package:app/base/api/api.dart';

class InformationBloc extends BlocBase with LoggingMixin {
  InformationBloc(BuildContext context, Store store) : super(context, store);

  var loading = 'loadingTag';
  static const loadingTag = {'name': 'loadingTag'};
  var words = <Map>[loadingTag];
  var textList = [
    "最新",
    "健康饮食",
    "运动减肥",
    "最新1",
    "健康饮食1",
    "运动减肥1",
    "最新2",
    "健康饮食2",
    "运动减肥2"
  ];
  bool show = false;
  String text = "最新";
  var lists = [];
  var indexPage = 1;
  bool indexshow = true;

  void startup() {}

  void to(String t) {
    const loadingTag = {'name': 'loadingTag'}; //表尾标记
    setModel(() {
      text = t;
      words = <Map>[loadingTag];
      indexPage = 1;
      indexshow = true;
    });
  }

  void click(int i) {
    log.info(i);
    navigate.pushNamed('/informationDetailsPage');
  }

  void retrieveData() async {
    var list = await Http().get(indexPage);
    lists = list[0]['channellist'];
    Future.delayed(Duration(seconds: lists.length == 0 ?  1 : 2)).then((e) {
      if (lists.length == 0) {
        setModel(() {
          indexshow = false;
        });
        return;
      }
      words.insertAll(
          words.length - 1,
          //每次生成20个单词
          lists.map((student) => student));

      setModel(() {
        indexPage = indexPage + 500;
      });
    });
  }
}
