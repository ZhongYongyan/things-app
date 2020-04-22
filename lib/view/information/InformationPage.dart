import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/information/InformationBloc.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class InformationPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<InformationPage, InformationBloc> {
  @override
  void initState() {
    super.initState();

    //_retrieveData();
  }

  @override
  InformationBloc createBloc(Store<StoreState> store) {
    return InformationBloc(context, store)..startup();
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
        centerTitle: true,
        title: Text("资讯",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
        backgroundColor: Colors.white,
      ),
      backgroundColor:
          bloc.textList.length == 0 ? Color(0xFFf8f8f8) : Colors.white,
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.topLeft, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              Positioned(
                  top: 0,
                  height: 1,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Color(0xFFF3F3F3),
                  )),
              Positioned(
                top: 1,
                height: 40,
                left: 0,
                right: 0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: bloc.textList
                      //每一个字母都用一个Text显示,字体为原来的两倍
                      .map(
                        (t) => GestureDetector(
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(0.0),
                            width: 88,
                            //容器内补白
                            //color: Colors.black,
                            alignment: Alignment.center,
                            child: Text(t.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: bloc.sortId == t.id
                                      ? Color(0xFF0079FE)
                                      : Color(0xFFA2A2A6),
                                  fontSize: 14,
                                  fontWeight: bloc.sortId == t.id
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                )),
                          ),
                          onTap: () => bloc.onToSelection(t.id), //点击
                        ),
                      )
                      .toList(),
                ),
              ),
              Positioned(
                  top: 41.0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Color(0xFFf8f8f8),
                    child: ListView.separated(
                      itemCount: bloc.words.length,
                      itemBuilder: (context, index) {
                        //如果到了表尾
                        if (bloc.words[index].title == bloc.loading) {
                          //不足100条，继续获取数据
                          if (bloc.indexshow && bloc.textList.length != 0) {
                            //获取数据
                            bloc.retrieveData(bloc.sortId);
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
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ));
                          }
                        }
                        //显示单词列表项
                        return GestureDetector(
                          child: Container(
                            height: 173,
                            margin: EdgeInsets.only(top: 10, left: 0, right: 0),
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Column(
                              //测试Row对齐方式，排除Column默认居中对齐的干扰
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  //height: 100,
                                  child: Padding(
                                    //左边添加8像素补白
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20, top: 12),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      children: <Widget>[
                                        Container(
                                          width: 4.0,
                                          height: 20,
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          color: Color(0xFF0079FE),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(bloc.words[index].title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Color(0xFF000000),
                                                fontSize: 16,
//                                                  fontWeight: FontWeight.w700,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 90,
                                  child: Padding(
                                    //左边添加8像素补白
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20, top: 12),
                                    child: Text(
                                        bloc.parseHtmlString(
                                            bloc.words[index].body),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color(0xFFA2A2A6),
                                          height: 1.6,
                                          fontSize: 14,
                                        )),
                                  ),
                                ),
                                Padding(
                                  //左边添加8像素补白
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Container(
                                    height: 1,
                                    color: Color(0xFFF3F3F3),
                                  ),
                                ),
                                Padding(
                                  //左边添加8像素补白
                                  padding: const EdgeInsets.only(
                                      top: 9.0, left: 20, right: 20),
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            child: Icon(Icons.timer,
                                                color: Color(0xFFA2A2A6)),
                                          ),
                                          Text(
                                              DateTime.parse(
                                                      bloc.words[index].updated)
                                                  .toString()
                                                  .substring(
                                                      0,
                                                      DateTime.parse(bloc
                                                                  .words[index]
                                                                  .updated)
                                                              .toString()
                                                              .length -
                                                          5),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Color(0xFFA2A2A6),
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text("阅读原文",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: Color(0xFFA2A2A6),
                                                  fontSize: 12,
                                                )),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              child: Icon(Icons.navigate_next,
                                                  color: Color(0xFFA2A2A6)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => bloc.onToDetails(index), //点击
                        );
                      },
                      separatorBuilder: (context, index) => Container(),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
