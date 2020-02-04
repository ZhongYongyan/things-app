import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/home/HomeBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:redux/src/store.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<HomePage, HomeBloc> {
  static const loadingTag = "##loading##"; //表尾标记
  var _words = <String>[loadingTag];

  @override
  void initState() {
    super.initState();
  }

  @override
  HomeBloc createBloc(Store<StoreState> store) {
    return HomeBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

//  _pageHead({@required Widget body}) {
//    return WillPopScope(
//      onWillPop: () {},
//      child: _pageBody()
//    );
//  }
  _pageBody() {
    //String str = "我是home我是home我是home我是home我是home我是home我是home我是home";
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: Container(
        // 显示进度条
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              Positioned(
                left: 10.0,
                top: 0,
                right: 10.0,
                bottom: 0,
                child: Container(
                  color: Color(0xFFF6F5F3),
                ),
//                Image.network(
//                  'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
//                  fit: BoxFit.fill,
//                ),
              ),
              Positioned(
                left: 10.0,
                height: 323,
                right: 10.0,
                bottom: 0,
                child: Container(
                  child: Image(
                    image: AssetImage("assets/u549.png"),
                  ),
                ),
//                Image.network(
//                  'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
//                  fit: BoxFit.fill,
//                ),
              ),
              Positioned(
                left: 0.0,
                top: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: new StaggeredGridView.countBuilder(
                    padding: const EdgeInsets.only(top: 0),
                    crossAxisCount: 4,
                    itemCount: 8,
                    itemBuilder: (BuildContext context, int index) =>
                        new Container(
                            child: new Container(
                                child: index == 0
                                    ? Image(
                                        image:
                                            AssetImage("assets/home_ban.png"),
                                        fit: BoxFit.cover,
                                      )
                                    : index == 1
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                left: 15, right: 15, top: 5),
                                            //color: Color(0xFF3578F7),
                                            child: Flex(
                                              direction: Axis.horizontal,
                                              children: <Widget>[
                                                Flex(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  direction: Axis.vertical,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 5,
                                                          ),
                                                          child: Image(
                                                            image: AssetImage(
                                                                "assets/home_y.png"),
                                                            fit: BoxFit.cover,
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          child: Text(bloc.name,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF3578F7),
                                                                fontSize: 16,
                                                              )),
                                                          onTap: () =>
                                                              bloc.to(), //点击
                                                        ),
                                                        GestureDetector(
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            child: Icon(
                                                                Icons
                                                                    .keyboard_arrow_down,
                                                                color: Color(
                                                                    0xFF3578F7)),
                                                          ),
                                                          onTap: () =>
                                                              bloc.to(), //点击
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                    ),
                                                    Text("点击右侧「添加设备」",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF333333),
                                                            fontSize: 15,
                                                            height: 1.5)),
                                                    Text("连接智能设备",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF333333),
                                                            fontSize: 15,
                                                            height: 1.5)),
                                                    Text("体验美好生活",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF333333),
                                                            fontSize: 15,
                                                            height: 1.5)),
                                                  ],
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(),
                                                ),
                                                Container(
                                                  width: 51,
                                                  height: 51,
//                                                  color: Color(
//                                                      0xFF3578F7),
                                                  child: GestureDetector(
                                                    child: ClipOval(
                                                      child: Container(
                                                        width: 51,
                                                        height: 51,
                                                        color:
                                                            Color(0xFF3578F7),
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () => bloc.add(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            margin: index.isEven
                                                ? const EdgeInsets.only(
                                                    left: 15)
                                                : const EdgeInsets.only(
                                                    right: 15),
                                            child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  //color: Color(0xFF000000),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                      color: Color(0xFF3578F7)),
                                                ),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  //指定未定位或部分定位widget的对齐方式
                                                  children: <Widget>[
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      bottom: 0,
                                                      left: 0,
                                                      child: Padding(
                                                        //左边添加8像素补白
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Flex(
                                                          direction:
                                                              Axis.horizontal,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Container(
                                                                child: Flex(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  direction: Axis
                                                                      .vertical,
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        child: Text(
                                                                            "设备名称",
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                              color: Color(0xFF3578F7),
                                                                              fontSize: 16,
                                                                            )),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.bottomCenter,
                                                                        child: Text(
                                                                            "SL-A100",
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                              color: Color(0xFF9CC5FF),
                                                                              fontSize: 12,
                                                                            )),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.bottomCenter,
                                                                        child: Text(
                                                                            "AI太空椅",
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                              color: Color(0xFF9CC5FF),
                                                                              fontSize: 12,
                                                                            )),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                child: Flex(
                                                                  direction: Axis
                                                                      .vertical,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: <
                                                                      Widget>[
                                                                    Image(
                                                                      image: AssetImage(
                                                                          "assets/yizi.png"),
                                                                      width:
                                                                          36.0,
                                                                      height:
                                                                          36.0,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(
                                                                              right: 5,
                                                                            ),
                                                                            child:
                                                                                Image(
                                                                              image: index.isEven ? AssetImage("assets/ok.png") : AssetImage("assets/on.png"),
                                                                              width: 13.0,
                                                                              height: 13.0,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                              index.isEven ? "在线" : '离线',
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.left,
                                                                              style: TextStyle(
                                                                                color: index.isEven ? Color(0xFF3578F7) : Color(0xFFCDCDCD),
                                                                                fontSize: 12,
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    index == 2
                                                        ? Positioned(
                                                            top: 0,
                                                            right: 0,
                                                            bottom: 0,
                                                            left: 0,
                                                            child: Opacity(
                                                              opacity: 0,
                                                              child: ClipRRect(
                                                                //剪裁为圆角矩形
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container()
                                                  ],
                                                )),
                                          ))),
                    staggeredTileBuilder: (int index) => index == 0
                        ? new StaggeredTile.count(4, 2.5)
                        : index == 1
                            ? new StaggeredTile.count(4, 1.3)
                            : new StaggeredTile.count(2, 1.1),
                    mainAxisSpacing: 15.0,
                    crossAxisSpacing: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}