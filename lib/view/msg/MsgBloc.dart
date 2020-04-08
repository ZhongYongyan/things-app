import 'dart:async';

import 'package:app/base/api/MemberNewsApis.dart';
import 'package:app/base/entity/MemberNews.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Page.dart';
import 'package:app/base/util/Result.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class MsgBloc extends BlocBase with LoggingMixin {
  MsgBloc(BuildContext context, Store store) : super(context, store);
  var loading = 'loadingTag';
  static var loadingTag = MemberNews.fromJson({'title': 'loadingTag'});
  var words = <MemberNews>[loadingTag];
  var textList = [];
  int sortId = 0;
  var lists = [];
  var indexPage = 1;
  bool indexshow = true;

  Future startup() async {}

  void onToDetails(int i) {
    navigate.pushNamed('/msgDetails', arguments: {"model": words[i]});
  }

  void retrieveData() async {
    lists = [];
    Result<Page> response =
        await MemberNewsApis.getMemberNews(indexPage, 10, "ASC");
    bool code = response.success;
    if(!code) {
      log.info("消息请求出错",response.message);
      setModel(() {
        indexshow = false;
      });
      return;
    }
    //错误处理
    lists = response.data.items;
    Future.delayed(Duration(seconds: 1)).then((e) {
      words.insertAll(words.length - 1, lists.map((student) => student));
      if (lists.length < 10) {
        setModel(() {
          indexshow = false;
        });
      } else {
        var newIndexPage = indexPage + 1;
        setModel(() {
          indexPage = newIndexPage;
        });
      }
    });
  }
}
