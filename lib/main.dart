import 'dart:io';

import 'package:app/config/AppRoute.dart';
import 'package:app/config/AppTheme.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
  }
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
