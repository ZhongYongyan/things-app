import 'package:app/module/informationDetails/InformationDetailsBloc.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class InformationDetailsPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<InformationDetailsPage, InformationDetailsBloc> {
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
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        //导航栏
//        elevation: 0,
        brightness: Brightness.light,
        title: Text("资讯",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            )),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WebView(
            initialUrl: 'https://www.baidu.com',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {

              },
            ),
          ],
        ),
      ),
    );
  }
}
