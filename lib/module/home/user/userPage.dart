import 'package:app/module/home/user/userBloc.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class UserPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<UserPage, UserBloc> {
  @override
  UserBloc createBloc(Store<StoreState> store) {
    return UserBloc(context, store)..startup();
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
        title: Text("用户管理",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            )),
        backgroundColor: Colors.white,
        actions: <Widget>[
          // 非隐藏的菜单
          new IconButton(
              icon: new Icon(
                Icons.add,
                color: Color(0xFF3578F7),
              ),
              //tooltip: 'Add Alarm',
              onPressed: () {
                bloc.toAdd();
              }),
          // 隐藏的菜单
        ],
      ),
      backgroundColor: Color(0xFFF9F9F9),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Container(
//            color: Color(0xFFF9F9F9),
            child: ListView.separated(
//              physics: const NeverScrollableScrollPhysics(),
              itemCount: bloc.words.length,
              itemBuilder: (context, index) {
                //如果到了表尾
                if (bloc.words[index] == bloc.loading) {
                  //不足100条，继续获取数据
                  if (bloc.words.length - 1 < 3) {
                    //获取数据
                    bloc.retrieveData();
                    //加载时显示loading
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(strokeWidth: 2.0)),
                    );
                  } else {
                    //已经加载了100条数据，不再获取数据。
                    return Container(
//                           alignment: Alignment.center,
//                           padding: EdgeInsets.all(16.0),
//                           child: Text("没有更多了", style: TextStyle(color: Colors.grey),)
                        );
                  }
                }
                //显示单词列表项
                return GestureDetector(
                  child: Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      height: 146,
                      child: ClipRRect(
                          //剪裁为圆角矩形
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            color: Colors.white,
                            padding:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: Column(
                                //测试Row对齐方式，排除Column默认居中对齐的干扰
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Image(
                                        image: AssetImage("assets/home_y.png"),
                                        fit: BoxFit.cover,
                                        width: 30,
                                        height: 30,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 31.0,
//                                          color: Colors.green,
                                        ),
                                      ),
                                      ClipRRect(
                                        //剪裁为圆角矩形
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        child: GestureDetector(
                                          child: Container(
                                            height: 31.0,
                                            width: 62.0,
                                            alignment: Alignment.center,
                                            color: Color(0xFF3578F7),
                                            child: Text("详情",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFFFFFFFF),
                                                  fontSize: 12,
                                                )),
                                          ),
                                          onTap: () =>
                                              bloc.toDatails(), //点击//长按
                                        ),
                                      )
                                    ],
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Container(
                                        width: 100,
                                        child: Text("昵称：爷爷",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Color(0xFF9A9A9A),
                                              fontSize: 12,
                                            )),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: 80,
                                        ),
                                        child: Text("性别：男",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Color(0xFF9A9A9A),
                                              fontSize: 12,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 26.0,
//                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Container(
                                        width: 100,
                                        child: Text("身高：170CM",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Color(0xFF9A9A9A),
                                              fontSize: 12,
                                            )),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: 80,
                                        ),
                                        child: Text("生日：1954-06-22",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Color(0xFF9A9A9A),
                                              fontSize: 12,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 26.0,
//                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Container(
                                        width: 100,
                                        child: Text("体重：60KG",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Color(0xFF9A9A9A),
                                              fontSize: 12,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 26.0,
//                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ))),

                  onTap: () => bloc.click(index), //点击
                );
              },
              separatorBuilder: (context, index) => Container(
                height: 0,
                color: Color(0xFFF3F3F3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
