import 'dart:async';

import 'package:app/base/api/AffiliateApis.dart';
import 'package:app/base/entity/Affiliate.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Paged.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/Auth.dart';
import 'package:app/store/module/lang/Langs.dart';
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

  String get visitor => state.lang.localized(Langs.visitor);

  String get name =>
      state.auth.userName != null ? state.auth.userName : visitor;

  String get userManagement => state.lang.localized(Langs.userManagement);

  String get userName => state.lang.localized(Langs.userName);

  String get userGender => state.lang.localized(Langs.userGender);

  String get userHeight => state.lang.localized(Langs.userHeight);

  String get userBirthday => state.lang.localized(Langs.userBirthday);

  String get userWeight => state.lang.localized(Langs.userWeight);

  String get male => state.lang.localized(Langs.male);

  String get female => state.lang.localized(Langs.female);

  Future startup() async {
    if (state.member.words.length >= 2) {
      setModel(() {
        words = state.member.words;
        indexPage = state.member.indexPage;
        indexshow = state.member.indexshow;
      });
      onRefresh();
    }
  }

  void onToAdd() {
    navigate.pushNamed('/userDetails',
        arguments: {"model": Affiliate.fromJson({})});
  }

  void onToDetails(int i) {
    navigate.pushNamed('/userDetails', arguments: {"model": words[i]});
  }

  void onGetname(int i) {
    var item = words[i];
    dispatch(authActions.select(item.id, item.nickname, item.avatar));
    navigate.pop();
  }

  void retrieveData() async {
    lists = [];
    Result<Paged> response =
        await AffiliateApis.getAffiliate(indexPage, 10, "DESC");
    bool code = response.success;

    var item = Affiliate.fromJson({
      "id": 123456,
      "memberId": 10,
      "nickname": "??????",
      "phone": "",
      "sex": "F",
      "height": 110,
      "weight": 60.0,
      "birthday": "2008-03-30T15:23:23.000+0000",
      "created": "",
      "companyId": 1324941137936416
    });
    //????????????
    lists = response.data.items;
    if (indexPage == 1) {
      lists.add(item);
    }
    Future.delayed(Duration(seconds: 1)).then((e) {
      words.insertAll(words.length - 1, lists.map((student) => student));
      if (response.data.pageCount <= indexPage) {
        setModel(() {
          indexshow = false;
        });
        state.member.indexshow = false;
      } else {
        var newIndexPage = indexPage + 1;
        setModel(() {
          indexPage = newIndexPage;
        });
        state.member.indexPage = newIndexPage;
      }
      /*if(response.data.pageCount > indexPage) {
        setModel(() {
          indexPage = indexPage + 1;
        });
      }
      state.member.words = words;*/
    });
  }

  void toBack() {
    navigate.pop();
  }

  Future<void> onRefresh() async {
    lists = [];
    words = <Affiliate>[loadingTag];
    Result<Paged> response = await AffiliateApis.getAffiliate(1, 10, "DESC");
    bool code = response.success;
    //????????????
    if (!code) {
      setModel(() {
        indexshow = false;
      });
      state.member.indexshow = false;
      await Future.delayed(Duration(seconds: 1)).then((e) {});
      return;
    }
    lists = response.data.items;
    var item = Affiliate.fromJson({
      "id": 123456,
      "memberId": 10,
      "nickname": "??????",
      "phone": "",
      "sex": "F",
      "height": 110,
      "weight": 60.0,
      "birthday": "2008-03-30T15:23:23.000+0000",
      "created": "",
      "companyId": 1324941137936416
    });
    lists.add(item);
    await Future.delayed(Duration(seconds: 1)).then((e) {
      words.insertAll(words.length - 1, lists.map((student) => student));
      if (response.data.pageCount > 1) {
        setModel(() {
          state.member.words = words;
          indexPage = 2;
          indexshow = true;
        });
      }else {
        setModel(() {
          state.member.words = words;
        });
      }
    });
  }
}
