import 'dart:async';
import 'dart:convert';

import 'package:app/base/blue/BlueBridge.dart';
import 'package:app/base/blue/Message.dart';
import 'package:app/base/plugin/PluginManager.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:redux/redux.dart';

class PluginBloc extends BlocBase with LoggingMixin {
  PluginBloc(BuildContext context, Store store) : super(context, store);

  static final flutterWebviewPlugin = new FlutterWebviewPlugin();
  final blueBridge = new BlueBridge(flutterWebviewPlugin);
  var loading = false;
  String pluginPath;

  void init() {}

  void loadPlugin(String pluginUrl, String deviceSn) {
    flutterWebviewPlugin.clearCache();
    flutterWebviewPlugin.close();
    computedPluginUrl(pluginUrl).then((url) {
      if(deviceSn != null) {
        url = url + '?accessToken=' + state.auth.accessToken + '&deviceSn=' + deviceSn;
      }
      log.info('pluginUrl: $url');
      setModel(() {
        this.pluginPath = url;
      });
    });

    flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      this.setModel(() {
        loading = true;
      });

      if (viewState.type == WebViewState.finishLoad) {
        log.info('WebViewState.finishLoad');

        this.setModel(() {
          loading = false;
        });

//        flutterWebviewPlugin.resize(
//            Rect.fromLTWH(0.0, 0.0, MediaQuery.of(context).size.width, 300.0));
      }
    });
  }

  void handleNavigate(String message) {
    log.info('handleNavigate: $message');
    Message msg = Message.fromJson(json.decode(message));
    switch (msg.command) {
      case 'exit':
        navigate.pop();
        msg.success(true);
        break;
      case 'setEnabledSystemUIOverlays':
        if (msg.data == 0) {
          // 隐藏顶部状态栏和底部操作栏
          SystemChrome.setEnabledSystemUIOverlays([]);
        } else {
          // 显示顶部状态栏和底部操作栏
          SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        }
        break;
      case 'setOrientation':
        if (msg.data == 'portrait') {
          AutoOrientation.portraitAutoMode();
        } else {
          AutoOrientation.landscapeAutoMode();
        }
        break;
    }
  }

  void _postMessage(Message message) {
    log.info('_postMessage: ${message.toJsonString()}');
    String script = "NativeBridge.handleMessage('${message.toJsonString()}');";
    flutterWebviewPlugin.evalJavascript(script);
  }

  void toBack() {
    navigate.pop();
    flutterWebviewPlugin.clearCache();
    flutterWebviewPlugin.close();
  }

  Future<String> computedPluginUrl(String url) async {
    PluginManager pluginManager = PluginManager();
    return pluginManager.download(url);
//    return 'https://www.baidu.com/';
  }
}
