import 'package:app/module/msg/MsgBloc.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class MsgPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<MsgPage, MsgBloc> {
  @override
  MsgBloc createBloc(Store<StoreState> store) {
    return MsgBloc(context, store)..startup();
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
        title: Text("消息",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.topLeft, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
//              Positioned(
//                top: 0,
//                height: 40,
//                left: 0,
//                right: 0,
//                child: Padding(
//                  //左边添加8像素补白
//                  padding: const EdgeInsets.only(left: 15.0),
//                  child: Flex(
//                    direction: Axis.horizontal,
//                    children: <Widget>[
//                      Text("消息",
//                          maxLines: 1,
//                          overflow: TextOverflow.ellipsis,
//                          textAlign: TextAlign.left,
//                          style: TextStyle(
//                            color: Color(0xFF333333),
//                            fontSize: 18,
//                            fontWeight: FontWeight.w700,
//                          )),
//                      Container(
//                          width: 220,
//                          height: 31,
//                          margin: const EdgeInsets.only(left: 30.0),
//                          child: DecoratedBox(
//                            decoration: BoxDecoration(
//                              border: Border.all(
//                                color: Color(0xFFF3F3F3),
//                              ),
//                              borderRadius: BorderRadius.circular(10.0), //3像素圆角
//                            ),
//                            child: TextField(
//                              style: TextStyle(
//                                  fontSize: 14.0, color: Colors.black),
//                              decoration: InputDecoration(
//                                hintText: "搜索消息",
//                                hintStyle: TextStyle(
//                                    fontSize: 14.0, color: Color(0xFFcccccc)),
//                                border: InputBorder.none,
//                                prefixIcon: Icon(
//                                  Icons.search,
//                                  color: Color(0xFFcccccc),
//                                ),
//                                contentPadding: EdgeInsets.all(4.0),
//                                disabledBorder: InputBorder.none,
//                                enabledBorder: InputBorder.none,
//                                focusedBorder: InputBorder.none,
//                              ),
//                            ),
//                          )),
//                    ],
//                  ),
//                ),
//              ),
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
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Color(0xFFF8F8F8),
                    child: ListView.separated(
                      itemCount: bloc.words.length,
                      itemBuilder: (context, index) {
                        //如果到了表尾
                        if (bloc.words[index].title == bloc.loading) {
                          //不足100条，继续获取数据
                          if (bloc.indexshow) {
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
//                        return Container(
//                            alignment: Alignment.center,
//                            padding: EdgeInsets.all(16.0),
//                            child: Text(
//                              "没有更多了",
//                              style: TextStyle(color: Colors.grey,fontSize:14),
//                            ));
                          }
                        }
                        //显示单词列表项
                        return GestureDetector(
                          child: Container(
                            height: 66,
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
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 10, top: 12),
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        children: <Widget>[
                                          ClipOval(
                                            child: Container(
                                              color: Color(0xFFE4E4E4),
                                              width: 42.0,
                                              height: 42.0,
                                              alignment: Alignment.center,
                                              child: Image(
                                                image: AssetImage(
                                                    "assets/image_$index.png"),
                                                fit: BoxFit.cover,
                                                width: 20.0,
                                                height: 20.0,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: SizedBox(
                                                height: 42.0,
                                                //Flex的三个子widget，在垂直方向按2：1：1来占用100像素的空间
                                                child: Flex(
                                                  direction: Axis.vertical,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            bloc.words[index]
                                                                .title,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF000000),
                                                                fontSize: 16,
                                                                height: 1.6
                                                                //fontWeight:FontWeight.w700,
                                                                )),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        margin: const EdgeInsets
                                                            .only(top: 4.0),
                                                        child: Text(
                                                            bloc.words[index]
                                                                .body,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFFA2A2A6),
                                                              fontSize: 12,
                                                              //fontWeight:FontWeight.w700,
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            child: Icon(Icons.navigate_next,
                                                color: Color(0xFFA2A2A6)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          onTap: () => bloc.onToDetails(index), //点击
                        );
                      },
                      separatorBuilder: (context, index) => Container(
                        height: 1,
                        color: Color(0xFFF3F3F3),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
