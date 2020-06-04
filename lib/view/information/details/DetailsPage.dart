import 'dart:async';
import 'dart:convert';

import 'package:app/base/api/InfoSortApis.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/information/details/DetailsBloc.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailsPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<DetailsPage, DetailsBloc> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  DetailsBloc createBloc(Store<StoreState> store) {
    return DetailsBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map;
    var model = args["model"];
    bloc.infoModel = model;
    bloc.setUI();
    Widget body = _pageBody();
    return body;
  }

  _pageBody() {
    return Scaffold(
        key: bloc.scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          title: Text("资讯详情",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              )),
          backgroundColor: Colors.white,
          // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        ),
        // We're using a Builder here so we have a context that is below the Scaffold
        // to allow calling Scaffold.of(context) so we can show a snackbar.
        body: SafeArea(
            child: WebView(
                //initialUrl: 'https://www.baidu.com',///初始化url
                javascriptMode: JavascriptMode.unrestricted,

                ///JS执行模式
                onWebViewCreated: (WebViewController webViewController) {
                  ///在WebView创建完成后调用，只会被调用一次
                  _controller.complete(webViewController);
                  final String contentBase64 =
                      base64Encode(const Utf8Encoder().convert(bloc.html));
                  _onExecJavascript(
                      'data:text/html;charset=utf-8;base64,$contentBase64');
                },
                javascriptChannels: <JavascriptChannel>[
                  ///JS和Flutter通信的Channel；
                  _toasterJavascriptChannel(context),
                ].toSet(),
                navigationDelegate: (NavigationRequest request) {
                  //路由委托（可以通过在此处拦截url实现JS调用Flutter部分）；
                  ///通过拦截url来实现js与flutter交互
                  if (request.url.startsWith('https://www.baidu.com')) {
                    //Fluttertoast.showToast(msg:'JS调用了Flutter By navigationDelegate');
                    print('blocking navigation to $request}');
                    return NavigationDecision.prevent;

                    ///阻止路由替换，不能跳转，因为这是js交互给我们发送的消息
                  }
                  return NavigationDecision.navigate;

                  ///允许路由替换
                },
                onPageFinished: (String url) {
                  ///页面加载完成回调
                  print('Page finished loading');
                })));
  }

  ///js与flutter交互
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toast', //Toaster要和网页协商一致
        onMessageReceived: (JavascriptMessage message) {
          String text = message.message;
          bloc.to(text);
        });
  }

  ///组合脚本执行方法，将数据发送给js端（flutter与js交互）
  void _onExecJavascript(String url) async {
    _controller.future.then((controller) {
      controller.loadUrl(url);
    });
    //或者 evaluateJavascript('callJS("js方法")')
  }
}
