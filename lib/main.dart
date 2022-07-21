import 'dart:io';

import 'package:app/base/AdminRequest.dart';
import 'package:app/base/NavigatorHolder.dart';
import 'package:app/config/AppRoute.dart';
import 'package:app/config/AppTheme.dart';
import 'package:app/store/Store.dart';
import 'package:app/store/module/GetuiHelper.dart';
import 'package:flutter/cupertino.dart';
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
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  Store store = await StoreConfig.config();
  runApp(MyApp(store));
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。
    // 写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    Getuiflut.initGetuiSdk;
  } else {
    Getuiflut().startSdk(
        appId: "itTyNzKYEQ71ojvDiBnNe9",
        appKey: "MTSHNGakyO7wB9fKNGPlM4",
        appSecret: "j0HkdyX31l9Xr8MJgqmWH9");
  }
  Getuiflut().resetBadge();
  getuiHelper.create();
}

class MyApp extends StatelessWidget {
  final Store<StoreState> store;

  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<StoreState>(
      store: store,
      child: MaterialApp(
        title: 'iRest健康云',
        theme: appTheme,
        navigatorKey: navigatorHolder.navigatorKey,
        onGenerateRoute: appRoute,
        debugShowCheckedModeBanner: false,//去除debug图标
      ),
    );
  }
}
