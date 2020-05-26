import 'dart:async';

import 'package:app/base/api/InfoSortApis.dart';
import 'package:app/base/entity/Info.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Page.dart';
import 'package:app/base/util/Result.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:redux/redux.dart';

class InformationBloc extends BlocBase with LoggingMixin {
  InformationBloc(BuildContext context, Store store) : super(context, store);

  var loading = 'loadingTag';
  static var loadingTag = Info.fromJson({'title': 'loadingTag'});
  var words = <Info>[loadingTag];
  RegExp reg = new RegExp(r"[\u4e00-\u9fa5]");
  var textList = [];
  int sortId = 0;
  var lists = [];
  var indexPage = 1;
  bool indexshow = true;

  Future startup() async {
    if (state.information.textList.length > 0) {
      setModel(() {
        textList = state.information.textList;
        sortId = state.information.sortId;
        indexshow =  state.information.indexshow;
        words = state.information.words;
        indexPage = state.information.indexPage;
      });
    }
    if(sortId == 0) {
      getInfoSortData();
    }
  }

  void getInfoSortData() async {
    Result<Page> response = await InfoSortApis.getInfoSort(1, 10, "ASC");
    bool code = response.success;
    //错误处理
    if(!code) {
      setModel(() {
        indexshow = false;
      });
      state.information.indexshow = false;
      return;
    }
    setModel(() {
      textList = response.data.items;
      sortId = response.data.items.length > 0 ? response.data.items.first.id : 0;
      indexshow =  response.data.items.length == 0 ? false : true;
    });
    state.information.textList = response.data.items;
    state.information.sortId = response.data.items.length > 0 ? response.data.items.first.id : 0;
    state.information.indexshow = response.data.items.length == 0 ? false : true;
  }

  void onToSelection(int id) {
    var loadingTag = Info.fromJson({'title': 'loadingTag'});
    state.information.sortId = id;
    state.information.indexPage = 1;
    state.information.words = <Info>[loadingTag];
    state.information.indexshow = true;
    setModel(() {
      sortId = id;
      words = <Info>[loadingTag];
      indexPage = 1;
      indexshow = true;
    });
  }

  void onToDetails(int i) {
    navigate.pushNamed('/details', arguments: {"model": words[i]});
  }

  void retrieveData(int sortId) async {
    if (sortId == 0) {
      return;
    }
    lists = [];
    Result<Page> response =
        await InfoSortApis.getInfo(indexPage, 10, "ASC", sortId);
    bool code = response.success;
    if(!code) {
      log.info("资讯请求出错",response.message);
      setModel(() {
        indexshow = false;
      });
      state.information.indexshow = false;
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
        state.information.indexshow = false;
      } else {
        var newIndexPage = indexPage + 1;
        setModel(() {
          indexPage = newIndexPage;
        });
        state.information.indexPage = newIndexPage;
      }
      state.information.words = words;
    });
  }

  String parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }
}
