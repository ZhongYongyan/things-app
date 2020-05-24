import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/msg/MsgBloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/src/store.dart';

class MsgPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<MsgPage, MsgBloc>  {
  @override
  MsgBloc createBloc(Store<StoreState> store) {
    return MsgBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }
  void initState() {
    super.initState();

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
                            print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
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
                        return msgItem(index);
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


  //单个item
  Widget msgItem(int index) {
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
                                "assets/image_0.png"),
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
                                Flex(
                                  direction: Axis.horizontal,
                                  children: <Widget>[
                                    msgText(bloc.words[index]
                                        .title,0),
                                    msgText(DateTime.parse(
                                        bloc.words[index].updated)
                                        .toString()
                                        .substring(
                                        0,
                                        DateTime.parse(bloc
                                            .words[index]
                                            .updated)
                                            .toString()
                                            .length -
                                            5),2)
                                  ],
                                ),
                                msgText(bloc.words[index]
                                    .body,1)
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
  }

  Widget msgText( String text, int start ) {
    return Expanded(
      flex: 1,
      child: Container(
        alignment: start == 2 ? Alignment
            .centerRight : Alignment
            .centerLeft,
        margin:start == 0 ? const EdgeInsets
            .only(top: 0.0) : const EdgeInsets
            .only(top: 4.0),
        child: Text(
            text,
            maxLines: 1,
            overflow:
            TextOverflow
                .ellipsis,
            textAlign:
            TextAlign.left,
            style: TextStyle(
              color: start == 0 ?  Color(
                  0xFF000000) : Color(
                  0xFFA2A2A6),
              fontSize: start == 0  ? 16 : 12,
              //fontWeight:FontWeight.w700,
            )),
      ),
    );
  }

}
