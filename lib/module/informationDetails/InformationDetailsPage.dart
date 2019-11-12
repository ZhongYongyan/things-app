import 'package:app/module/informationDetails/InformationDetailsBloc.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:convert';

const String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
 <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/2.1.2/weui.min.css">
<head><title>Navigation Delegate Example</title></head>
<body>
<a href="javascript:;" onclick="callFlutter('hello word')" class="weui-btn weui-btn_primary">页面主操作</a>
<div class="page article js_show">
    <div class="page__bd">
        <article class="weui-article">
            <section>
                <h2 class="title">章标题</h2>
                <section>
                    <h3>1.1 节标题</h3>
                    <p>
                        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
                        tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
                        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
                        consequat.
                    </p>
                    <p>
                        <img src="http://pic19.nipic.com/20120218/2634566_095236339148_2.jpg" alt="">
                        <img src="http://pic19.nipic.com/20120218/2634566_095236339148_2.jpg" alt="">
                    </p>
                </section>
                <section>
                    <h3>1.2 节标题</h3>
                    <p>
                        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
                        tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
                        cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
                        proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                    </p>
                </section>
            </section>
        </article>
    </div>
</div>
</body>
<script>
  function callFlutter(text) {
    Toast.postMessage("点击了页面主操作按钮" + text);
  }
  
</script>
</html>
''';

class InformationDetailsPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<InformationDetailsPage, InformationDetailsBloc> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  InformationDetailsBloc createBloc(Store<StoreState> store) {
    return InformationDetailsBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

//  _pageHead({@required Widget body}) {
//    return WillPopScope(
//      onWillPop: () {},
//      child: _pageBody()
//    );
//  }
  _pageBody() {
    return Scaffold(
        key: bloc.scaffoldKey,
        appBar: AppBar(
          title: const Text('Flutter WebView example'),
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
              final String contentBase64 = base64Encode(
                  const Utf8Encoder().convert(kNavigationExamplePage));
              _onExecJavascript('data:text/html;base64,$contentBase64');
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
            },
          ),
        ));
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
