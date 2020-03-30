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
          JavascriptChannel(
              name: 'PluginNative',
              onMessageReceived: (JavascriptMessage message) {
                bloc.handleNavigate(message.message);
              }),
        ].toSet(),
        url: ' http://192.168.3.223:8081/#/connectBlue',
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        ignoreSSLErrors: true,
        withJavascript: true,
        allowFileURLs: true,
        appBar: bloc.loading
            ? AppBar(
                elevation: 0,
                brightness: Brightness.light,
                centerTitle: true,
                leading: new IconButton(
                  icon: Container(
                    margin: const EdgeInsets.only(top: 2.0),
                    child: Image(
                      image: AssetImage("assets/back.png"),
                      fit: BoxFit.cover,
                      width: 22,
                      height: 22,
                    ),
                  ),
                  onPressed: () {
                    bloc.toBack();
                  },
                ),
              )
            : null,
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
