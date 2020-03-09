import 'dart:convert';

import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/plugin/PluginBloc.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PluginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<PluginPage, PluginBloc> {
  @override
  PluginBloc createBloc(Store<StoreState> store) {
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
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: WebView(
            initialUrl: 'https://things.sf.npu.fun/plugin/a800/index.html#/',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              bloc.webViewController.complete(webViewController);
            },
            javascriptChannels: <JavascriptChannel>[
              bloc.toasterJavascriptChannel(context),
            ].toSet(),
            onPageFinished: (String url) {
              print('Page finished loading');
            },
          ),
        ),
      ),
    );
  }
}
