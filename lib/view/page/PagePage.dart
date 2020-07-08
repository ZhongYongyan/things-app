import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/home/HomePage.dart';
import 'package:app/view/information/InformationPage.dart';
import 'package:app/view/msg/MsgPage.dart';
import 'package:app/view/my/MyPage.dart';
import 'package:app/view/page/PageBloc.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class PagePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<PagePage, PageBloc> {
  bool show = false;
  int currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    InformationPage(),
    MsgPage(),
    MyPage()
  ];
  final List<BottomNavigationBarItem> _list = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('首页',
          style: TextStyle(
            fontSize: 12,
          )),
      //backgroundColor: Colors.orange
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.book),
      title: Text('资讯',
          style: TextStyle(
            fontSize: 12,
          )),
      //backgroundColor: Colors.orange
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.fiber_new),
      title: Text('消息',
          style: TextStyle(
            fontSize: 12,
          )),
      //backgroundColor: Colors.orange
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      title: Text('我的',
          style: TextStyle(
            fontSize: 12,
          )),
      //backgroundColor: Colors.orange
    ),
  ];

  @override
  PageBloc createBloc(Store<StoreState> store) {
    return PageBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

  _pageBody() {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: currentIndex,
        items: _list,
        fixedColor: Color(0xFF3578F7),
        unselectedItemColor: Color(0xFFCCCCCC),
      ),
      //body: _children[_currentIndex],
      body: IndexedStack(
        index: currentIndex,
        children: _children,
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
