import 'dart:async';
import 'dart:convert';

import 'package:app/base/blue/BleNetworkPlugin.dart';
import 'package:app/base/blue/BlueBridge.dart';
import 'package:app/base/blue/Message.dart';
import 'package:app/base/plugin/PluginManager.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/store/module/Auth.dart';
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

  void loadPlugin(String pluginUrl, String deviceSn, String blueName,double softwareVersions,double firmwareVersions) {
    flutterWebviewPlugin.clearCache();
    flutterWebviewPlugin.close();
    computedPluginUrl(pluginUrl).then((url) {
      //url = "http://192.168.0.103:8080/#connectBlue" + '?accessToken=' + state.auth.accessToken;
      url = url + '?accessToken=' + state.auth.accessToken;
      if(deviceSn != null) {
        url = url + '&deviceSn=' + deviceSn + '&blueName=' + blueName + "&softwareVersions=" + softwareVersions.toString() + "&firmwareVersions=" + firmwareVersions.toString();
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
        _postMessage(msg.success(true));
        break;
      case 'setEnabledSystemUIOverlays':
        if (msg.data == 0) {
          // ???????????????????????????????????????
          SystemChrome.setEnabledSystemUIOverlays([]);
        } else {
          // ???????????????????????????????????????
          SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        }
        _postMessage(msg.success(true));
        break;

      case 'setOrientation':
        if (msg.data == 'portrait') {
          //????????????
          AutoOrientation.portraitAutoMode();
        } else {
          //????????????
          AutoOrientation.landscapeAutoMode();
        }
        _postMessage(msg.success(true));
        break;

      case 'configNetworkForRemoteDevice':
        var ssid = msg.data[0];
        var password = msg.data[1];
        var blueName = msg.data[2];
        BleNetworkPlugin.configNetworkForRemoteDevice(ssid, password, blueName)
            .then((value) {
          _postMessage(msg.success(value));
        }).catchError((error) {
          log.info('APP:configNetworkForRemoteDevice error: $error');
          _postMessage(msg.failure('error', ""));
        });
        break;

      case 'setAffiliate':
        var id = msg.data[0];
        var nickname = msg.data[1];
        var avatar = msg.data[2];
        dispatch(authActions.select(id, nickname,avatar));
        _postMessage(msg.success(true));
        break;

      case 'getAffiliate':
        _postMessage(msg.success(state.auth.affiliateId));
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
