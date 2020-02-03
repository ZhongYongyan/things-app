import 'package:app/module/home/user/add/AddBloc.dart';
import 'package:app/module/home/user/component/UsercomPage.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                            bloc.back();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
          ),

          brightness: Brightness.light,
          title: Text("新建用户",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              )),
          backgroundColor: Colors.white,
          actions: <Widget>[
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
                      fontSize: 16.0
                  );
                  bloc.back();
                })
          ],
        ),
        backgroundColor: Color(0xFFF9F9F9),
        body: Container(
          child: Scrollbar(
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
                          child: Text("保存",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 16,
                              )),
                          color: Color(0xFF0079FE),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )

    );
  }
}
