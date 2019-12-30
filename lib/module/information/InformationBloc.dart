import 'dart:convert';
import 'package:app/base/api/InfoSortApis.dart';
import 'package:app/packages.dart';
import 'package:app/util/Page.dart';
import 'package:app/util/Result.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'dart:async';
import 'package:app/base/entity/Info.dart';

class InformationBloc extends BlocBase with LoggingMixin {
  InformationBloc(BuildContext context, Store store) : super(context, store);

  var loading = 'loadingTag';
  static var loadingTag = Info.fromJson({'title': 'loadingTag'});
  var words = <Info>[loadingTag];
  var textList = [];
  int sortId = 0;
  var lists = [];
  var indexPage = 1;
  bool indexshow = true;

  Future startup() async {
    getInfoSortData();
  }
  void getInfoSortData() async {
    Result<Page> response = await InfoSortApis.getInfoSort(1, 10, "ASC");
    bool code = response.success;
    //错误处理
    setModel(() {
      textList =  response.data.items;
      sortId = response.data.items.first.id;
    });
  }

  void onToSelection(int id) {
    var loadingTag = Info.fromJson({'title': 'loadingTag'});
    setModel(() {
      sortId = id;
      words = <Info>[loadingTag];
      indexPage = 1;
      indexshow = true;
    });
  }

  void onToDetails(int i) {
    navigate.pushNamed('/details',arguments: {"model":words[i]});
  }

  void retrieveData(int sortId) async {
    if  (sortId == 0) {
      return;
    }
    lists = [];
    Result<Page> response = await InfoSortApis.getInfo(indexPage, 10, "ASC",sortId);
    bool code = response.success;
    //错误处理
    lists = response.data.items;
    Future.delayed(Duration(seconds:1)).then((e) {
      words.insertAll(
          words.length - 1,
          lists.map((student) => student));
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
