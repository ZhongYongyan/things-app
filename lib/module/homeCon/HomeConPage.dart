import 'package:app/module/homeCon/HomeConBloc.dart';
import 'package:app/module/home/HomePage.dart';
import 'package:app/module/information/InformationPage.dart';
import 'package:app/module/msg/MsgPage.dart';
import 'package:app/module/my/MyPage.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class HomeConPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<HomeConPage, HomeConBloc> {
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
      icon: Icon(Icons.music_video),
      title: Text('消息',
          style: TextStyle(
            fontSize: 12,
          )),
      //backgroundColor: Colors.orange
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.movie),
      title: Text('我的',
          style: TextStyle(
            fontSize: 12,
          )),
      //backgroundColor: Colors.orange
    ),
  ];

  @override
  HomeConBloc createBloc(Store<StoreState> store) {
    return HomeConBloc(context, store)..startup();
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
//      appBar: AppBar( //导航栏
//        title: Text(["首页","资讯","消息","我的"][bloc.currentIndex],style: TextStyle(
//          color: Colors.white
//        )
//    ),
//        backgroundColor:Colors.black,
//      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: bloc.currentIndex,
        items: _list,
        fixedColor: Color(0xFF3578F7),
        unselectedItemColor: Color(0xFFCCCCCC),
      ),
      //body: _children[_currentIndex],
      body: IndexedStack(
        index: bloc.currentIndex,
        children: _children,
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      bloc.currentIndex = index;
    });
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String str = "我是home我是home我是home我是home我是home我是home我是home我是home";
    return Scrollbar(
      // 显示进度条
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            //动态创建一个List<Widget>
            children: str
                .split("")
                //每一个字母都用一个Text显示,字体为原来的两倍
                .map((c) => Text(
                      c,
                      textScaleFactor: 2.0,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class Book extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String str = "我是book我是book我是book我是book我是book我是book我是book我是book我是book";
    return Scrollbar(
      // 显示进度条
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            //动态创建一个List<Widget>
            children: str
                .split("")
                //每一个字母都用一个Text显示,字体为原来的两倍
                .map((c) => Text(
                      c,
                      textScaleFactor: 2.0,
                    ))
                .toList(),
          ),
        ),
      ),
    );
    print(str);
  }
}

class Music extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String str = "我是Music我是Music我是Music我是Music我是Music我是Music我是Music我是Music";
    return Scrollbar(
      // 显示进度条
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            //动态创建一个List<Widget>
            children: str
                .split("")
                //每一个字母都用一个Text显示,字体为原来的两倍
                .map((c) => Text(
                      c,
                      textScaleFactor: 2.0,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class Movie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String str = "我是Movie我是Movie我是Movie我是Movie我是Movie我是Movie我是Movie我是Movie";
    return Scrollbar(
      // 显示进度条
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            //动态创建一个List<Widget>
            children: str
                .split("")
                //每一个字母都用一个Text显示,字体为原来的两倍
                .map((c) => Text(
                      c,
                      textScaleFactor: 2.0,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
