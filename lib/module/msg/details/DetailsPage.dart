import 'package:app/module/msg/details/DetailsBloc.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:convert';
const String head = '''<!DOCTYPE html><html> <meta charset="utf-8"> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta name="viewport" content="width=device-width, initial-scale=1"> <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/2.1.2/weui.min.css"><link rel="stylesheet" href="https://at.alicdn.com/t/font_1538853_7adh1rzr8ao.css"> <head><title>Navigation Delegate Example</title></head> <body>''';
const String food = '''</body>
<style>
img{
  width:250px;
  height: 188px;
  margin: 0 auto;
  display: block;
  padding: 0;
}
p{
  font-size:12px;
  line-height: 24px;
  margin: 0;
  padding: 0;
  color: #666;
  margin-top: 20px;
}
.text{
  padding: 0 20px;
  margin: 0;
  margin-top: -10px;
}

</style>
<script>
  function callFlutter(text) {
    Toast.postMessage("点击了页面主操作按钮" + text);
  }
  
</script>
</html>''';
const String kNavigationExamplePage = head + '''
    <div class="text">
                <p>　　你有没有发现自己每天早上起床后总是昏昏沉沉，双腿像灌了铅一样。脸色晦暗发黄，还长痘长斑，黑眼圈跟熊猫似的。上班就会犯困，吃饭没有胃口，还经常失眠，睡觉出虚汗。最重要的是，开始有了消不下去的小肚腩和水肿腿。</p>
                <p>　　如果你有以上多种症状，我想这肯定就是体内湿气太重的原因，花点时间看完这篇文章，或许会有一些启发。</p>
                <p>　　什么是湿气呢?中医认为自然界中气候潮湿、食肉等是湿气的来源，湿邪过重则易伤阳气。在致病的风、寒、暑、湿、燥、火这“六淫邪气” 中，中医最怕湿邪。湿邪为病，多发生在夏秋之交，但四季均可发生。</p>
                <p>　　继8月23日台风“天鸽”登陆广东珠海，8月27日台风“帕卡”登陆广东台山，“玛娃”这个熊孩子在原地打圈圈数次，蛇形前进后终于登陆广东珠三角。而一波未平，一波又起!台风“玛娃”刚走，又有热带低压在菲律宾以东的洋面上生成，预计会成为今年第17号台风!</p>
                <p>　　它会不会再次登陆广东省，谁也说不准，不过你们可以先记住它的名字——古超。真心希望不要再下雨了，台风三连击带来的雨水有多猛，大家的体会都很深，毫不夸张，皮划艇都出动了!</p>
                <p>　　接连大雨，地处湿气重的地区或者房间不通风透气，都极易加重人体内的湿气。在沿海地区，大部分人体内都有湿气。</p>
              </div>
''' + food;

class MsgDetailsPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<MsgDetailsPage, MsgDetailsBloc> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  MsgDetailsBloc createBloc(Store<StoreState> store) {
    return MsgDetailsBloc(context, store)..startup();
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
          title: const Text('消息详情'),
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
