import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/my/MyBloc.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class MyPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<MyPage, MyBloc> {
  @override
  MyBloc createBloc(Store<StoreState> store) {
    return MyBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    bloc.h = MediaQuery.of(context).size.height;
    Widget body = _pageBody();
    return body;
  }

  _pageBody() {
    return Scaffold(
//      appBar: AppBar(
//        //导航栏
//        elevation: 0,
//        brightness: Brightness.light,
//        title: Text("",
//            style: TextStyle(
//              color: Colors.white,
//              fontSize: 14,
//              fontWeight: FontWeight.w700,
//            )),
//        backgroundColor: Colors.white,
//      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.topLeft, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
//              Positioned(
//                  top: 0,
//                  height: 40,
//                  left: 0,
//                  right: 0,
//                  child: Container(
//                    color: Color(0xFFFFFFFF),
//                    child: Padding(
//                      //左边添加8像素补白
//                      padding: const EdgeInsets.only(left: 15.0),
//                      child: Flex(
//                        direction: Axis.horizontal,
//                        children: <Widget>[
//                          Text("我的",
//                              maxLines: 1,
//                              overflow: TextOverflow.ellipsis,
//                              textAlign: TextAlign.left,
//                              style: TextStyle(
//                                color: Color(0xFF333333),
//                                fontSize: 18,
//                                fontWeight: FontWeight.w700,
//                              )),
//                        ],
//                      ),
//                    ),
//                  )),
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Color(0xFFF8F8F8),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bloc.words.length,
                      itemBuilder: (context, index) {
                        //如果到了表尾
                        if (bloc.words[index] == bloc.loading) {
                          //不足100条，继续获取数据
                          if (bloc.words.length - 1 < 7) {
                            //获取数据
                            bloc.retrieveData();
                            //加载时显示loading
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              alignment: Alignment.center,
                              child: SizedBox(
                                  width: 24.0,
                                  height: 24.0,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.0)),
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
                            height: index == 0 ? 112 : 51,
                            margin: index == 1 || index == 3 || index == 5
                                ? const EdgeInsets.only(top: 15)
                                : const EdgeInsets.only(top: 0),
                            alignment: Alignment.centerLeft,
                            color: Colors.white,
                            child: Column(
                                //测试Row对齐方式，排除Column默认居中对齐的干扰
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    //height: 100,
                                    child: Padding(
                                      //左边添加8像素补白
                                      padding: index == 0
                                          ? const EdgeInsets.only(
                                              left: 15.0, right: 10, top: 20)
                                          : const EdgeInsets.only(
                                              left: 15.0, right: 10, top: 13.5),
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        children: <Widget>[
                                          index == 0
                                              ? ClipOval(
                                                  child: Image.network(
                                                    'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
                                                    width: 72,
                                                    height: 72,
                                                    //fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Container(
                                                  width: 22.0,
                                                  height: 22.0,
                                                  child: Image(
                                                    image: AssetImage(
                                                        "assets/my_$index.png"),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Container(
                                                child: Text(
                                                    bloc.textList[index],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          index != 0 ? 16 : 18,
                                                      //height: 1.6
                                                      fontWeight: index != 0
                                                          ? FontWeight.normal
                                                          : FontWeight.w700,
                                                    )),
                                              ),
                                            ),
                                          ),
                                          index != 0
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 5),
                                                  child: Icon(
                                                      Icons.navigate_next,
                                                      color: Color(0xFFCCCCCC)),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          onTap: () => bloc.click(index), //点击
                        );
                      },
                      separatorBuilder: (context, index) => Container(
                        height: 1,
                        color: Color(0xFFF3F3F3),
                      ),
                    ),
                  )),
              Positioned(
                bottom: bloc.h < 812 ? 10 : 50,
                left: 20,
                right: 20,
                child: ClipRRect(
                  //剪裁为圆角矩形
                  borderRadius: BorderRadius.circular(5.0),
                  child: GestureDetector(
                    child: Container(
                      height: 46,
                      alignment: Alignment.center,
                      color: Color(0xFF0079FE),
                      child: Text("退出登录",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 16,
                          )),
                    ),
                    onTap: () => bloc.signout(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
