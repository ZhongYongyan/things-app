import 'dart:convert';

import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/plugin/PluginBloc.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:redux/src/store.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PluginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<PluginPage, PluginBloc> {
  @override
  PluginBloc createBloc(Store<StoreState> store) {
    AutoOrientation.landscapeAutoMode();
    return PluginBloc(context, store)..startup();
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
        url: "https://things.sf.npu.fun/plugin/a800/index.html#/",
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        ignoreSSLErrors: true,
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
