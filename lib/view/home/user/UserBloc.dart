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
  String get name => state.auth.name != null ? state.auth.name : '访客';

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
    dispatch(authActions.user(words[i].nickname));
    dispatch(authActions.url(words[i].avatar));
    navigate.pop();
  }

  void retrieveData() async {
    lists = [];
    Result<Page> response =
        await AffiliateApis.getAffiliate(indexPage, 10, "DESC");
    bool code = response.success;

    var item = Affiliate.fromJson({
      "id": 123456,
      "memberId": 10,
      "nickname": "访客",
      "phone": "",
      "sex": "F",
      "height": 110,
      "weight": 60.0,
      "birthday": "2008-03-30T15:23:23.000+0000",
      "created": "",
      "companyId": 1324941137936416
    });
    //错误处理
    lists = response.data.items;
    if (indexPage == 1) {
      lists.add(item);
    }
    log.info(lists);
    log.info("++++++++++++++++++++++++++++++++++++++++");
    Future.delayed(Duration(seconds: 1)).then((e) {
      words.insertAll(words.length - 1, lists.map((student) => student));
      if (lists.length < 10) {
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
      state.member.words = words;
    });
  }

  void toBack() {
    navigate.pop();
  }

  Future<void> onRefresh() async {
    print("开始刷新数据");
    lists = [];
    Result<Page> response =
    await AffiliateApis.getAffiliate(1, 10, "ASC");
    bool code = response.success;
    //错误处理
    if (!code) {
      log.info("刷新数据出错", response.message);
      setModel(() {
        indexshow = false;
      });
      state.member.indexshow = false;
      await Future.delayed(Duration(seconds: 1)).then((e){

      });
      return;
    }
    lists = response.data.items;
    var num = 0;
    var listItem = [];
    await Future.delayed(Duration(seconds: 1)).then((e){
      for (int i = 0; i < lists.length; i++)
      {
        var ageOver = words.where((student) => student.id == lists[i].id || student.nickname == "loadingTag" ||  student.id == 123456);
        if (ageOver.toList().length > 2 ) {
          print("重复数据");
        } else {
          num += 1;
          listItem.add(lists[i]);
        }
        if(i == lists.length -1 && num > 0) {
          print("更新了${listItem.length}----------------条数据");
          words.insertAll(0, listItem.map((student) => student));
          //state.member.words.insertAll(0, listItem.map((student) => student));
          print("数据${words.length}----------------条数据");
          setModel(() {
            indexshow = state.member.indexshow;
          });
        }
      }

    });
  }
}

