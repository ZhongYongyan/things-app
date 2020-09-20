import 'dart:async';

import 'package:app/base/api/InfoSortApis.dart';
import 'package:app/base/entity/Info.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Page.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:redux/redux.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InformationBloc extends BlocBase with LoggingMixin {
  InformationBloc(BuildContext context, Store store) : super(context, store);
  String get info => state.lang.localized(Langs.info);
  String get infoTips => state.lang.localized(Langs.infoTips);
  String get read => state.lang.localized(Langs.read);
  var loading = 'loadingTag';
  static var loadingTag = Info.fromJson({'title': 'loadingTag'});
  var words = <Info>[loadingTag];
  RegExp reg = new RegExp(r"[\u4e00-\u9fa5]");
  var textList = [];
  int sortId = 0;
  var lists = [];
  var indexPage = 1;
  bool indexshow = true;
  bool stopShow = false;
  Future startup() async {
    if (state.information.textList.length > 0) {
      setModel(() {
        textList = state.information.textList;
        sortId = state.information.sortId;
        indexshow = state.information.indexshow;
        words = state.information.words;
        indexPage = state.information.indexPage;
      });
    }
    if (sortId == 0) {
      getInfoSortData();
    }
  }

  void getInfoSortData() async {
    Result<Page> response = await InfoSortApis.getInfoSort(1, 30, "ASC");
    bool code = response.success;
    //错误处理
    if (!code) {
      setModel(() {
        indexshow = false;
      });
      state.information.indexshow = false;
      return;
    }
    setModel(() {
      textList = response.data.items;
      sortId =
          response.data.items.length > 0 ? response.data.items.first.id : 0;
      indexshow = response.data.items.length == 0 ? false : true;
    });
    state.information.textList = response.data.items;
    state.information.sortId =
        response.data.items.length > 0 ? response.data.items.first.id : 0;
    state.information.indexshow =
        response.data.items.length == 0 ? false : true;
  }

  void onToSelection(int id) {
    if(stopShow) {
      return;
    }
    var loadingTag = Info.fromJson({'title': 'loadingTag'});
    var sortIdArr = state.information.allWords.where((student) => student.sortId == id || student.title == "loadingTag");
    var  newIndexshow = state.information.indexshow;
    var  newIndexPage = state.information.indexPage;
    for (int i = 0; i < state.information.allTitleWords.length; i++)
    {
      if(state.information.allTitleWords[i]["sortId"] == id)
      {
        newIndexshow = state.information.allTitleWords[i]["indexshow"];
        newIndexPage = state.information.allTitleWords[i]["indexPage"];
      }
    }
    state.information.sortId = id;
    state.information.indexPage = sortIdArr.toList().length>1 ? newIndexPage : 1;
    state.information.words = sortIdArr.toList().length>1 ? sortIdArr.toList() :  <Info>[loadingTag];
    state.information.indexshow = sortIdArr.toList().length>1 ? newIndexshow : true;
    setModel(() {
      sortId = id;
      words = sortIdArr.toList().length>1 ? sortIdArr.toList() :  <Info>[loadingTag];
      indexPage = sortIdArr.toList().length>1 ? newIndexPage : 1;
      indexshow = sortIdArr.toList().length>1 ? newIndexshow : true;
    });
  }

  void onToDetails(int i) {
    navigate.pushNamed('/details', arguments: {"model": words[i]});
  }

  void retrieveData(int sortId) async {
    if (sortId == 0) {
      return;
    }
    //这里找到之前改sortId 请求状态
    var ageOver = state.information.allTitleWords.where((student) => student["sortId"] == sortId);
    if(ageOver.toList().length > 0 ) {
      //请求过相同页
      if(ageOver.toList()[0]["indexPage"] == indexPage) {
        print("请求过相同页");
        setModel(() {
          indexshow = false;
        });
        return;
      }
    } else {
      var item = {
        "sortId":sortId,
        "indexshow":true,
        "indexPage":1,
      };
      state.information.allTitleWords.add(item);
    }

    lists = [];
    stopShow = true;
    Result<Page> response =
        await InfoSortApis.getInfo(indexPage, 10, "DESC", sortId);
    bool code = response.success;
    if (!code) {
      log.info("资讯请求出错", response.message);
      setModel(() {
        indexshow = false;
      });
      state.information.indexshow = false;
      stopShow = false;
      return;
    }
    //错误处理
    lists = response.data.items;


    //
    //这里页数相同不请求
    Future.delayed(Duration(seconds: 1)).then((e) {
      stopShow = false;
      state.information.allWords.insertAll(state.information.allWords.length - 1, lists.map((student) => student));
      words.insertAll(words.length - 1, lists.map((student) => student));
      if (lists.length < 10) {
        //这里找到之前改sortId 请求状态
        for (int i = 0; i < state.information.allTitleWords.length; i++)
        {
          if(state.information.allTitleWords[i]["sortId"] == sortId)
            {
              state.information.allTitleWords[i]["indexshow"] = false;
            }
        }
        setModel(() {
          indexshow = false;
        });
        state.information.indexshow = false;
      } else {
        var newIndexPage = indexPage + 1;
        //这里找到之前改sortId 请求状态
        for (int i = 0; i < state.information.allTitleWords.length; i++)
        {
          if(state.information.allTitleWords[i]["sortId"] == sortId)
          {
            state.information.allTitleWords[i]["indexPage"] = newIndexPage;
          }
        }
        setModel(() {
          indexPage = newIndexPage;
        });
        state.information.indexPage = newIndexPage;
      }

//      if(lists.length > 0 && words.length > 1 && lists.first.sortId != words.first.sortId) {
//        print("快速切换bug");
//      } else {
//        state.information.words = words;
//      }
    });
  }

  String parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }



  Future<void> onRefresh() async {
    print("开始刷新数据");
    if (textList.length == 0) {
      log.info("没有分类数据时下拉走到这里");
      getInfoSortData();
      return;
    }
    lists = [];
    stopShow = true;
    Result<Page> response =
    await InfoSortApis.getInfo(1, 10, "DESC", sortId);
    bool code = response.success;
    //错误处理
    if (!code) {
      log.info("刷新数据出错", response.message);
      setModel(() {
        indexshow = false;
      });
      state.information.indexshow = false;
      await Future.delayed(Duration(seconds: 1)).then((e){
        stopShow = false;
      });
      return;
    }
    lists = response.data.items;
    await Future.delayed(Duration(seconds: 1)).then((e){
      stopShow = false;
      if(lists.length > 0) {
        var loadingTag = Info.fromJson({'title': 'loadingTag'});
        words = <Info>[loadingTag];
        state.information.allWords.removeWhere((item) => item.sortId == sortId);
        words.insertAll(0, lists.map((student) => student));
        state.information.allWords.insertAll(0, lists.map((student) => student));
      }
      for (int j = 0; j < state.information.allTitleWords.length; j++)
      {
        if(state.information.allTitleWords[j]["sortId"] == sortId)
        {
          setModel(() {
            indexshow = lists.length < 10 ? false : true;
            indexPage = lists.length < 10 ? 1 : 2;
          });
          state.information.allTitleWords[j]["indexPage"] = lists.length < 10 ? 1 : 2;
          state.information.allTitleWords[j]["indexshow"] = lists.length < 10 ? false : true;
        }
      }

    });
  }
}
