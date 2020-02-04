import 'dart:async';

import 'package:app/base/api/AffiliateApis.dart';
import 'package:app/base/entity/Affiliate.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Page.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/Auth.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class UserBloc extends BlocBase with LoggingMixin {
  UserBloc(BuildContext context, Store store) : super(context, store);
  var loading = 'loadingTag';
  static var loadingTag = Affiliate.fromJson({'nickname': 'loadingTag'});
  var words = <Affiliate>[loadingTag];
  var textList = [];
  int sortId = 0;
  var lists = [];
  var indexPage = 1;
  bool indexshow = true;

  Future startup() async {}

  void onToAdd() {
    navigate.pushNamed('/userDetails',
        arguments: {"model": Affiliate.fromJson({})});
  }

  void onToDetails(int i) {
    navigate.pushNamed('/userDetails', arguments: {"model": words[i]});
  }

  void onGetname(int i) {
    dispatch(authActions.user(words[i].nickname));
    navigate.pop();
  }

  void retrieveData() async {
    lists = [];
    Result<Page> response =
        await AffiliateApis.getAffiliate(indexPage, 10, "ASC");
    bool code = response.success;
    log.info("w222222222222222");
    log.info(code);
    log.info("w222222222222222");
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

  void toBack() {
    navigate.pop();
  }
}