import 'package:app/module/launch/LaunchBloc.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class LaunchPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<LaunchPage, LaunchBloc> {
  @override
  LaunchBloc createBloc(Store<StoreState> store) {
    return LaunchBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return _pageHead(body: body);
  }

  _pageHead({@required Widget body}) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _pageBody(),
      ),
    );
  }

  _pageBody() {
    return Stack(children: <Widget>[
//      PageView.custom(
//        childrenDelegate: new SliverChildBuilderDelegate(
//          (context, index) {
//            return new Center(
//              child: Image(
//                image: _screenImage(index),
//                height: 1280,
//                width: 720,
//                fit: BoxFit.cover,
//              ),
//            );
//          },
//          childCount: 1,
//        ),
//      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        top: 0,
        child: Container(
          alignment: Alignment.center,
          child: Image(
            image: AssetImage(
                "assets/logo.png"),
            fit: BoxFit.cover,
            width: 224,
            height: 224,
          ),
        ),
      ),
      Positioned(
        bottom: 100,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(strokeWidth: 2.0)),
        ),
      ),

//      SafeArea(
//          child: Column(
//        children: <Widget>[
//          Expanded(
//            flex: 2,
//            child: Center(
//              child: Wrap(
//                direction: Axis.vertical,
//                children: <Widget>[
//                  Image(
//                    image: AssetImage("assets/app_icon_1024.png"),
//                    width: 150.0,
//                    height: 150.0,
//                  ),
//                  SizedBox(
//                      width: 150.0,
//                      child: Text(
//                        '华腾智控',
//                        textAlign: TextAlign.center,
//                        style: TextStyle(fontSize: 18),
//                      ))
//                ],
//              ),
//            ),
//          ),
//          Expanded(
//            flex: 1,
//            child: Center(),
//          ),
//          Expanded(
//            flex: 2,
//            child: Visibility(
//              visible: bloc.actionsVisible,
//              child: Padding(
//                padding: EdgeInsets.only(bottom: 20),
//                child: Wrap(
//                  runAlignment: WrapAlignment.end,
//                  children: <Widget>[
//                    Row(
//                      children: <Widget>[
//                        Expanded(
//                          flex: 1,
//                          child: Padding(
//                            padding: EdgeInsets.only(left: 20, right: 20),
//                            child: FlatButton(
//                              color: Theme.of(context)
//                                  .buttonTheme
//                                  .colorScheme
//                                  .primary,
//                              shape: new RoundedRectangleBorder(
//                                  borderRadius: new BorderRadius.circular(5.0)),
//                              child: Text("登录"),
//                              onPressed: bloc.loginHandler,
//                            ),
//                          ),
//                        )
//                      ],
//                    ),
//                    SizedBox(width: double.infinity, height: 20),
//                    Row(
//                      children: <Widget>[
//                        Expanded(
//                          flex: 1,
//                          child: Padding(
//                            padding: EdgeInsets.only(left: 20, right: 20),
//                            child: FlatButton(
//                              shape: new RoundedRectangleBorder(
//                                  borderRadius: new BorderRadius.circular(5.0)),
//                              color: Color(0xddffffff),
//                              child: Text("注册"),
//                              onPressed: bloc.registerHandler,
//                            ),
//                          ),
//                        )
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          ),
//        ],
//      ))
    ]);
  }

  ImageProvider _screenImage(index) {
    int i = index % 2;
    return AssetImage('assets/screen_image_$i.jpeg');
  }
}
