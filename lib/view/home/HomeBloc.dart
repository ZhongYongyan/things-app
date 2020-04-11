import 'dart:async';

import 'package:app/base/api/AffiliateApis.dart';
import 'package:app/base/api/InfoSortApis.dart';
import 'package:app/base/entity/Info.dart';
import 'package:app/base/entity/InfoSort.dart';
import 'package:app/base/plugin/PluginManager.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Page.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/Auth.dart';
import 'package:flutter/material.dart';
import 'package:getuiflut/getuiflut.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';

class HomeBloc extends BlocBase with LoggingMixin {
  HomeBloc(BuildContext context, Store store) : super(context, store);
  bool show = false;
  Timer _timer;
  String get name => state.auth.name != null ? state.auth.name : '访客';

  void startup() {
    var vm = this;
    if (name == "访客") {
      getUser();
    }
    Getuiflut().addEventHandler(
      onReceiveClientId: (String message) async {
        print("flutter onReceiveClientId+++++++++++++++++++++++: $message"); // 注册收到 cid 的回调

      },
      onRegisterDeviceToken: (String message) async {
        print("flutter onRegisterDeviceToken+++++++++++++++++++++++: $message"); // 注册收到 cid 的回调
      },
      onReceivePayload: (Map<String, dynamic> message) async {

      },
      onReceiveNotificationResponse: (Map<String, dynamic> message) async {
        var id = message["aps"]["category"];
        _timer = new Timer(const Duration(milliseconds: 400), () {
          vm.getDelInfoSort(int.parse(id));
        });
      },
      onAppLinkPayload: (String message) async {

      },
      onRegisterVoipToken: (String message) async {

      },
      onReceiveVoipPayLoad: (Map<String, dynamic> message) async {

      },
      onReceiveMessageData: (Map<String, dynamic> msg) async {
        print("flutter onReceiveMessageData: $msg"); // 透传消息的内容都会走到这里

      },
      onNotificationMessageArrived: (Map<String, dynamic> msg) async {
        print("flutter onNotificationMessageArrived"); // 消息到达的回调

      },
      onNotificationMessageClicked: (Map<String, dynamic> msg) async {
        print("flutter onNotificationMessageClicked"); // 消息点击的回调
      },
    );
  }
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
  void to() {
    navigate.pushNamed('/user');
  }

  void add() {
    navigate.pushNamed('/management');
  }

  void toPlugin() {
    navigate.pushNamed('/plugin', arguments: {"url": ""});
  }
  void getDelInfoSort(int id) async {
    Result<Info> response = await InfoSortApis.getDelInfoSort(id);
    bool code = response.success;
    if(code){
      navigate.pushNamed('/details', arguments: {"model": response.data});
    } else {
      print("详情请求失败了");
    }
  }
  void getUser() async {
    Result<Page> response = await AffiliateApis.getAffiliate(1, 10, "ASC");
    bool code = response.success;
    var list = response.data.items;
    if (list.length > 0) {
      dispatch(authActions.user(list[0].nickname));
    }
  }
}
