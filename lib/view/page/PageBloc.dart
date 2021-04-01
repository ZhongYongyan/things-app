import 'package:app/base/api/MemberNewsApis.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class PageBloc extends BlocBase with LoggingMixin {
  PageBloc(BuildContext context, Store store) : super(context, store);
  String get home => state.lang.localized(Langs.home);
  String get info => state.lang.localized(Langs.info);
  String get message => state.lang.localized(Langs.message);
  String get me => state.lang.localized(Langs.me);
  List<BottomNavigationBarItem> list = <BottomNavigationBarItem>[];
  int createNumber = 1;
  void startup() {
    getByCreateNewsNumber();
    list = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text(home,
            style: TextStyle(
              fontSize: 12,
            )),
        //backgroundColor: Colors.orange
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.book),
        title: Text(info,
            style: TextStyle(
              fontSize: 12,
            )),
        //backgroundColor: Colors.orange
      ),
      BottomNavigationBarItem(
//        icon: Icon(Icons.fiber_new),
//        title: Text(message,
//            style: TextStyle(
//              fontSize: 12,
//            )),
        //backgroundColor: Colors.orange
          title: new Text(message),
          icon: new Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Icon(Icons.message),
                state.app.createNumber > 0 ? Positioned(  // draw a red marble
                  top: 2,
                  right: -6.0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 12,
                    ),
                    child: new Text(
                      state.app.createNumber > 99 ?   '……' : state.app.createNumber.toString(),
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ) : Positioned(
                  top: 2,
                  right: -6.0,
                  child: Container(),
                ),
              ]
          ),
          activeIcon:new Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Icon(Icons.message),
                state.app.createNumber > 0 ? Positioned(  // draw a red marble
                  top: 2,
                  right: -6.0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 12,
                    ),
                    child: new Text(
                      state.app.createNumber > 99 ?  '……' : state.app.createNumber.toString(),
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ) : Positioned(
                  top: 2,
                  right: -6.0,
                  child: Container(),
                ),
              ]
          )
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text(me,
            style: TextStyle(
              fontSize: 12,
            )),
        //backgroundColor: Colors.orange
      ),
    ];
  }

  //获取当前用户为信息条数
  void getByCreateNewsNumber() async {
    int number = await MemberNewsApis.getByCreateNewsNumber();
    if (number != state.app.createNumber) {
      setModel(() {
        state.app.createNumber = number;
        list[2] = BottomNavigationBarItem(
//        icon: Icon(Icons.fiber_new),
//        title: Text(message,
//            style: TextStyle(
//              fontSize: 12,
//            )),
          //backgroundColor: Colors.orange
            title: new Text(message),
            icon: new Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Icon(Icons.message),
                  state.app.createNumber > 0 ? Positioned(  // draw a red marble
                    top: 2,
                    right: -6.0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 12,
                      ),
                      child: new Text(
                        state.app.createNumber > 99 ?  '……' : state.app.createNumber.toString(),
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ) : Positioned(
                    top: 2,
                    right: -6.0,
                    child: Container(),
                  ),
                ]
            ),
            activeIcon:new Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Icon(Icons.fiber_new),
                  state.app.createNumber > 0 ? Positioned(  // draw a red marble
                    top: 2,
                    right: -6.0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 12,
                      ),
                      child: new Text(
                        state.app.createNumber > 99 ?  '……' : state.app.createNumber.toString(),
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ) : Positioned(
                    top: 2,
                    right: -6.0,
                    child: Container(),
                  ),
                ]
            )
        );
      });
    }
  }
}
