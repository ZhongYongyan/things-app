import 'dart:async';

import 'package:app/base/api/AffiliateApis.dart';
import 'package:app/base/api/DeviceVoApis.dart';
import 'package:app/base/api/InfoSortApis.dart';
import 'package:app/base/api/SoftwareApis.dart';
import 'package:app/base/entity/DeviceVo.dart';
import 'package:app/base/entity/Info.dart';
import 'package:app/base/entity/InfoSort.dart';
import 'package:app/base/entity/Software.dart';
import 'package:app/base/plugin/PluginManager.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Page.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/Auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getuiflut/getuiflut.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';

class HomeBloc extends BlocBase with LoggingMixin {
  HomeBloc(BuildContext context, Store store) : super(context, store);
  bool show = false;
  var onReceiveClientId = "";
  Timer _timer;
  bool loadShow = false;
  String get name => state.auth.name != null ? state.auth.name : '访客';
  var DeviceVoModel = DeviceVo.fromJson({});
  void startup() {
    var vm = this;
    if (name == "访客") {
      getUser();
    }
    getDeviceVo();
    Getuiflut().addEventHandler(
      onReceiveClientId: (String message) async {
        print("flutter onReceiveClientId+++++++++++++++++++++++: $message"); // 注册收到 cid 的回调
        onReceiveClientId = message;
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

  Future<void> toPlugin(int index) async {
    var id = DeviceVoModel.deviceModels[index-2].id;
    setModel(() {
      loadShow = true;
    });
    Result<Software> response = await SoftwareApis.getSoftware(id);
    bool code = response.success;
    setModel(() {
      loadShow = false;
    });
    //错误处理
    if(!code) {
      Fluttertoast.showToast(
          msg: "没有找到插件，请与系统管理员联系",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    navigate.pushNamed('/plugin', arguments: {"url": response.data.url});
  }
  //推送消息跳转详情
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
      //创建别名 用于别名推送
      Getuiflut().bindAlias(list[0].memberId, onReceiveClientId);
      dispatch(authActions.user(list[0].nickname));
    }
  }

  void getDeviceVo() async {
    Result<DeviceVo> response = await DeviceVoApis.getDeviceVo();
    bool code = response.success;
    if(code){
      var data = response.data;
      setModel(() {
        DeviceVoModel = data;
      });
      print("++++++++++2dada++++++$data");
    } else {

    }
  }

}
