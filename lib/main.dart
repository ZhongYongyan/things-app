import 'dart:io';

import 'package:app/config/AppRoute.dart';
import 'package:app/config/AppTheme.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:getuiflut/getuiflut.dart';
import 'package:redux/redux.dart';

import 'base/util/LoggingUtils.dart';
import 'base/util/StorageUtils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LoggingConfig.config();
  await StorageConfig.config();

  Store store = await StoreConfig.config();

  runApp(MyApp(store));
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。
    // 写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    Getuiflut.initGetuiSdk;
  } else {
    Getuiflut().startSdk(
        appId: "itTyNzKYEQ71ojvDiBnNe9",
        appKey: "MTSHNGakyO7wB9fKNGPlM4",
        appSecret: "j0HkdyX31l9Xr8MJgqmWH9"
    );
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

class MyApp extends StatelessWidget {
  final Store<StoreState> store;

  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<StoreState>(
      store: store,
      child: MaterialApp(
        title: '健康云',
        theme: appTheme,
        //navigatorKey: NavigatorHolder.navigatorKey,
        onGenerateRoute: appRoute,
      ),
    );
  }
}
