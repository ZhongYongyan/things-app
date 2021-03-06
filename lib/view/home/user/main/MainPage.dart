import 'package:app/view/home/user/details/DatailsPage55.dart';
import 'package:app/view/home/user/rate/RatePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
//        //?????????
//        elevation: 0,
//        leading: new IconButton(
//          icon: new Container(
//            padding: EdgeInsets.all(0.0),
//            child: Container(
//              alignment: Alignment.center,
//              margin: const EdgeInsets.only(right: 0),
//              child: new Text("??????",
//                  textAlign: TextAlign.center,
//                  style: TextStyle(color: Color(0xFF0079FE), fontSize: 14)),
//            ),
//          ),
//          onPressed: () {
//            showDialog(
//                context: context,
//                builder: (BuildContext context) {
//                  return CupertinoAlertDialog(
//                    title: Text("????????????", style: TextStyle(fontSize: 16)),
//                    content: Container(
//                      margin: const EdgeInsets.only(top: 5),
//                      child: Text("??????????????????????????????????????????"),
//                    ),
//                    actions: <Widget>[
//                      CupertinoDialogAction(
//                        child: Text("??????"),
//                        onPressed: () {
//                          Navigator.pop(context);
//                          print("??????");
//                        },
//                      ),
//                      CupertinoDialogAction(
//                        child: Text("??????"),
//                        onPressed: () {
//                          print("??????");
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
//        title: Text("????????????",
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
//                child: new Text("??????",
//                    textAlign: TextAlign.center,
//                    style: TextStyle(color: Color(0xFF0079FE), fontSize: 14)),
//              ),
//              onPressed: () {
//                Fluttertoast.showToast(
//                    msg: "????????????",
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
//                child: new Text("??????",
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
//          Center(child: Text('????????????')),
//          Center(child: Text('??????')),
//          Center(child: Text('??????')),
//          Center(child: Text('??????')),
//          Center(child: Text('??????')),
//          Center(child: Text('??????')),
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
    with TickerProviderStateMixin {
  BuildContext topContext = null;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  int index = 0;
  List item = [
    "????????????",
    "????????????",
    "??????",
    "??????",
    "??????",
    "??????",
    "??????",
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
    topContext = context;

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
          indicatorColor: Color(0xFF0079FE),
          labelColor: Color(0xFF333333),
          indicatorWeight: 4,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.only(left: 5, right: 5),
          labelPadding: EdgeInsets.only(left: 8, right: 8),
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
        //?????????
        elevation: 0,
        leading: new IconButton(
          icon: new Container(
            padding: EdgeInsets.all(0.0),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 0),
              child: new Text("??????",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF0079FE), fontSize: 14)),
            ),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text("????????????", style: TextStyle(fontSize: 16)),
                    content: Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text("??????????????????????????????????????????"),
                    ),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text("??????"),
                        onPressed: () {
                          Navigator.pop(context);
                          print("??????");
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text("??????"),
                        onPressed: () {
                          print("??????");
                          //bloc.back();
                          Navigator.pop(context);
                          //Navigator.of(topContext).pop();
                        },
                      ),
                    ],
                  );
                });
          },
        ),

        brightness: Brightness.light,
        title: Text("????????????",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            )),
        backgroundColor: Colors.white,
        actions: <Widget>[
          index == 0
              ? new IconButton(
                  icon: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 0),
                    child: new Text("??????",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Color(0xFF0079FE), fontSize: 14)),
                  ),
                  onPressed: () {
                    Fluttertoast.showToast(
                        msg: "????????????",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    //bloc.back();
                  })
              : new IconButton(
                  icon: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 0),
                    child: new Text("??????",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Color(0xFF0079FE), fontSize: 14)),
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
