import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:app/base/blue/BlueBridge.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/store/module/Auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:redux/redux.dart';

class PluginBloc extends BlocBase with LoggingMixin {
  PluginBloc(BuildContext context, Store store) : super(context, store);

  static final flutterWebviewPlugin = new FlutterWebviewPlugin();
  final blueBridge = new BlueBridge(flutterWebviewPlugin);

  void init() {
    flutterWebviewPlugin.close();

    var loadLocalFile = false;
    flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.finishLoad) {
        log.info('WebViewState.finishLoad');

//        if (!loadLocalFile) {
//          loadLocalFile = true;
//          String fileHtmlContents =
//              await rootBundle.loadString('assets/test.html');
//          flutterWebviewPlugin.launch(Uri.dataFromString(fileHtmlContents,
//                  mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
//              .toString());
//        }

//        flutterWebviewPlugin.resize(
//            Rect.fromLTWH(0.0, 0.0, MediaQuery.of(context).size.width, 300.0));
      }
    });
  }
}
