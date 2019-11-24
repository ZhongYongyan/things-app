import 'package:app/module/home/user/details/datailsBloc.dart';
import 'package:app/module/home/user/component/usercomPage.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class DatailsPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<DatailsPage, datailsBloc> {
  @override
  datailsBloc createBloc(Store<StoreState> store) {
    return datailsBloc(context, store)..startup();
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
          title: Text("用户详情",
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
                    height: 41,
                    color: Colors.white,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: bloc.list
                          //每一个字母都用一个Text显示,字体为原来的两倍
                          .map(
                            (t) => GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                padding: EdgeInsets.all(0.0),
//                                width: 70, //容器内补白
                                //color: Colors.black,
                                alignment: Alignment.center,
                                child: Text(t,
                                    style: TextStyle(
                                      color: bloc.text == t
                                          ? Color(0xFF3578F7)
                                          : Color(0xFF666666),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                              //onTap: () => bloc.to(t), //点击
                            ),
                          )
                          .toList(),
//                children: <Widget>[
//                  Column(
//                    //动态创建一个List<Widget>
//
//                  ),

//
//                ],
                    ),
                  ),

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
        ));
  }
}
