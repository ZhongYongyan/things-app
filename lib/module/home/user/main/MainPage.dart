import 'package:app/module/home/user/main/MianBloc.dart';
import 'package:app/module/home/user/details/DatailsPage.dart';
import 'package:app/module/home/user/rate/RatePage.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/src/store.dart';

//class MainPage extends StatefulWidget {
//  @override
//  _State createState() => _State();
//}
//
//class _State extends BlocState<MainPage, MainBloc> with SingleTickerProviderStateMixin {
//
//  @override
//  MainBloc createBloc(Store<StoreState> store) {
//    bloc. tabController = TabController(vsync: this, length:bloc.item.length);
//    return MainBloc(context, store)..startup();
//  }
//  @override
//  Widget createWidget(BuildContext context) {
//    Widget body = _pageBody();
//    return body;
//  }
//  _pageBody() {
//    return Scaffold(
//      key: bloc.scaffoldKey,
//      endDrawer: Drawer(
//        child: MediaQuery.removePadding(
//          context: context,
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Expanded(
//                child: ListView(
//                  children: <Widget>[
//                    ListTile(
//                      leading: const Icon(Icons.add),
//                      title: const Text('Add account'),
//                    ),
//                    ListTile(
//                      leading: const Icon(Icons.settings),
//                      title: const Text('Manage accounts'),
//                    ),
//                  ],
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//      appBar: AppBar(
//        bottom: TabBar(
//          indicatorColor:Color(0xFF0079FE),
//          labelColor: Color(0xFF333333),
//          indicatorWeight: 4,
//          isScrollable: true,
//          indicatorSize:TabBarIndicatorSize.tab,
//          indicatorPadding: EdgeInsets.only(left: 5,right: 5),
//          labelPadding: EdgeInsets.only(left: 8,right: 8),
//          unselectedLabelStyle: TextStyle(
//            fontSize: 14.0,
//          ),
//          labelStyle: TextStyle(
//            fontSize: 14.0,
//            fontWeight: FontWeight.w700,
//          ),
//          tabs: bloc.item
//              .map((item) => Tab(
//            text: item,
//          ))
//              .toList(),
//          controller: bloc.tabController, //1
//        ),
//        //导航栏
//        elevation: 0,
//        leading: new IconButton(
//          icon: new Container(
//            padding: EdgeInsets.all(0.0),
//            child: Container(
//              alignment: Alignment.center,
//              margin: const EdgeInsets.only(right: 0),
//              child: new Text("取消",
//                  textAlign: TextAlign.center,
//                  style: TextStyle(color: Color(0xFF0079FE), fontSize: 14)),
//            ),
//          ),
//          onPressed: () {
//            showDialog(
//                context: context,
//                builder: (BuildContext context) {
//                  return CupertinoAlertDialog(
//                    title: Text("确认退出", style: TextStyle(fontSize: 16)),
//                    content: Container(
//                      margin: const EdgeInsets.only(top: 5),
//                      child: Text("资料尚未保存，是否取消编辑？"),
//                    ),
//                    actions: <Widget>[
//                      CupertinoDialogAction(
//                        child: Text("取消"),
//                        onPressed: () {
//                          Navigator.pop(context);
//                          print("取消");
//                        },
//                      ),
//                      CupertinoDialogAction(
//                        child: Text("确定"),
//                        onPressed: () {
//                          print("确定");
//                          //bloc.back();
//                          Navigator.pop(context);
//                        },
//                      ),
//                    ],
//                  );
//                });
//          },
//        ),
//
//        brightness: Brightness.light,
//        title: Text("用户详情",
//            style: TextStyle(
//              color: Colors.black,
//              fontSize: 14,
//              fontWeight: FontWeight.w700,
//            )),
//        backgroundColor: Colors.white,
//        actions: <Widget>[
//          bloc.index == 0 ?
//          new IconButton(
//              icon: Container(
//                alignment: Alignment.center,
//                margin: const EdgeInsets.only(right: 0),
//                child: new Text("保存",
//                    textAlign: TextAlign.center,
//                    style: TextStyle(color: Color(0xFF0079FE), fontSize: 14)),
//              ),
//              onPressed: () {
//                Fluttertoast.showToast(
//                    msg: "保存成功",
//                    toastLength: Toast.LENGTH_SHORT,
//                    gravity: ToastGravity.CENTER,
//                    timeInSecForIos: 1,
//                    textColor: Colors.white,
//                    fontSize: 16.0);
//                //bloc.back();
//              }) :  new IconButton(
//              icon: Container(
//                alignment: Alignment.center,
//                margin: const EdgeInsets.only(right: 0),
//                child: new Text("筛选",
//                    textAlign: TextAlign.center,
//                    style: TextStyle(color: Color(0xFF0079FE), fontSize: 14)),
//              ),
//              onPressed: () {
//                bloc.scaffoldKey.currentState.openEndDrawer();
//              })
//        ],
//      ),
//      body: TabBarView(
//        controller: bloc.tabController,
//        children: <Widget>[
//          DatailsPage(),
//          Center(child: Text('睡眠情况')),
//          Center(child: Text('血压')),
//          Center(child: Text('心率')),
//          Center(child: Text('情绪')),
//          Center(child: Text('血流')),
//          Center(child: Text('呼吸')),
//        ],
//      ),
//    );
//  }
//}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  int index = 0;
  List item = [
    "基本信息",
    "睡眠情况",
    "血压",
    "心率",
    "情绪",
    "血流",
    "呼吸",
  ];

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: item.length);
    _tabController.addListener(() {
      setState(() {
        index = _tabController.index;
      });
      print(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: MediaQuery.removePadding(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('Add account'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Manage accounts'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        bottom: TabBar(
          indicatorColor:Color(0xFF0079FE),
          labelColor: Color(0xFF333333),
          indicatorWeight: 4,
          isScrollable: true,
          indicatorSize:TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.only(left: 5,right: 5),
          labelPadding: EdgeInsets.only(left: 8,right: 8),
          unselectedLabelStyle: TextStyle(
            fontSize: 14.0,
          ),
          labelStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
          tabs: item
              .map((item) => Tab(
                    text: item,
                  ))
              .toList(),
          controller: _tabController, //1
        ),
        //导航栏
        elevation: 0,
        leading: new IconButton(
          icon: new Container(
            padding: EdgeInsets.all(0.0),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 0),
              child: new Text("取消",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF0079FE), fontSize: 14)),
            ),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text("确认退出", style: TextStyle(fontSize: 16)),
                    content: Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text("资料尚未保存，是否取消编辑？"),
                    ),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text("取消"),
                        onPressed: () {
                          Navigator.pop(context);
                          print("取消");
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text("确定"),
                        onPressed: () {
                          print("确定");
                          //bloc.back();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                });
          },
        ),

        brightness: Brightness.light,
        title: Text("用户详情",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            )),
        backgroundColor: Colors.white,
        actions: <Widget>[
          index == 0 ?
          new IconButton(
              icon: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 0),
                child: new Text("保存",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF0079FE), fontSize: 14)),
              ),
              onPressed: () {
                Fluttertoast.showToast(
                    msg: "保存成功",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    textColor: Colors.white,
                    fontSize: 16.0);
                //bloc.back();
              }) :  new IconButton(
              icon: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 0),
                child: new Text("筛选",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF0079FE), fontSize: 14)),
              ),
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              })
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          UserDatailsPage(),
          RatePage(),
          RatePage(),
          RatePage(),
          RatePage(),
          RatePage(),
          RatePage(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
