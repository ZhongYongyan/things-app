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
  void startup() {
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
        icon: Icon(Icons.fiber_new),
        title: Text(message,
            style: TextStyle(
              fontSize: 12,
            )),
        //backgroundColor: Colors.orange
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
}
