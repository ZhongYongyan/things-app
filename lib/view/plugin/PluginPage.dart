import 'dart:convert';

import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/plugin/PluginBloc.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:redux/src/store.dart';

class PluginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<PluginPage, PluginBloc> {
  @override
  void initState() {
    // AutoOrientation.landscapeAutoMode();
  }

  @override
  PluginBloc createBloc(Store<StoreState> store) {
    log.info('createBloc');
    return PluginBloc(context, store)..init();
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

  _pageBody() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new WebviewScaffold(
        javascriptChannels: [
          JavascriptChannel(
              name: 'BlueNative',
              onMessageReceived: (JavascriptMessage message) {
                bloc.blueBridge.handleMessage(message.message);
              }),
        ].toSet(),
        url: 'http://192.168.0.233:8081/#/demo/testblue',
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        ignoreSSLErrors: true,
        withJavascript: true,
        allowFileURLs: true,
        initialChild: Container(
          color: Colors.white,
          child: const Center(
            child: Text('Waiting.....'),
          ),
        ),
      ),
    );
  }
}
