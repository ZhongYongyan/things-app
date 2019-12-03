import 'package:app/module/home/user/details/DatailsBloc.dart';
import 'package:app/module/home/user/component/UsercomPage.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/src/store.dart';

class UserDatailsPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<UserDatailsPage, DatailsBloc> {
  @override
  DatailsBloc createBloc(Store<StoreState> store) {
    return DatailsBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

  _pageBody() {
    return Scaffold(

      backgroundColor: Color(0xFFF9F9F9),
      body:Container(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(0.0),
            child:Column(
              //动态创建一个List<Widget>
              children: <Widget>[
                Container(
                  //width: 200,
                  height: 500,
//                  width: 375,
                  child: UsercomPage(),
                ),
//
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  height: 46,
//                    color: Color(0xFF000000))
                  child: ClipRRect(
                    //剪裁为圆角矩形
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text("删除",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 16,
                          )),
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
        ),
      ),
//
    );
  }
}
