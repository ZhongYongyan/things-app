import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/launch/LaunchBloc.dart';
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
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        top: 0,
        child: Container(
          alignment: Alignment.center,
          child: Image(
            image: AssetImage("assets/logo.jpg"),
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
    ]);
  }

  ImageProvider _screenImage(index) {
    int i = index % 2;
    return AssetImage('assets/screen_image_$i.jpeg');
  }
}
