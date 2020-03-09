import 'dart:async';

import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/store/module/Auth.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PluginBloc extends BlocBase with LoggingMixin {
  PluginBloc(BuildContext context, Store store) : super(context, store);

  final Completer<WebViewController> webViewController =
      Completer<WebViewController>();

  void startup() {}

  JavascriptChannel toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toast',
        onMessageReceived: (JavascriptMessage message) {
          String text = message.message;
        });
  }

  void onExecJavascript(String url) async {
    webViewController.future.then((controller) {
      controller.loadUrl(url);
    });
  }
}
