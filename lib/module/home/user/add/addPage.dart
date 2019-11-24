import 'package:app/module/home/user/add/addBloc.dart';
import 'package:app/module/home/user/component/usercomPage.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class AddPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<AddPage, AddBloc> {
  @override
  AddBloc createBloc(Store<StoreState> store) {
    return AddBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

  _pageBody() {
    return Scaffold(
        appBar: AppBar(
          //导航栏
          elevation: 0,
          brightness: Brightness.light,
          title: Text("新建用户",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              )),
          backgroundColor: Colors.white,
          actions: <Widget>[
            // 非隐藏的菜单
//          new IconButton(
//              icon: new Icon(
//                Icons.add,
//                color: Color(0xFF3578F7),
//              ),
////              tooltip: 'Add Alarm',
//              onPressed: () {}),
            // 隐藏的菜单
          ],
        ),
        backgroundColor: Color(0xFFF9F9F9),
        body: Scrollbar(
          // 显示进度条
          child: SingleChildScrollView(
//          padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                //动态创建一个List<Widget>
                children: <Widget>[
                  Container(
                    //width: 200,
                    height: 420,
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
        ));
  }
}
