import 'package:app/base/entity/DeviceModelAll.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/home/management/ManagementBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class ManagementPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<ManagementPage, ManagementBloc> {
  @override
  ManagementBloc createBloc(Store<StoreState> store) {
    return ManagementBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

  _pageBody() {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: SafeArea(
        bottom: false,
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              Positioned(
                left: 5.0,
                top: 0,
                height: 36,
                child: Container(
                  child: IconButton(
                    icon: Container(
                      margin: const EdgeInsets.only(top: 2.0),
                      child: Image(
                        image: AssetImage("assets/back.png"),
                        fit: BoxFit.cover,
                        width: 22,
                        height: 22,
                      ),
                    ),
                    onPressed: () {
                      bloc.back();
                    },
                  ),
                ),
              ),
              Positioned(
                left: 60.0,
                right: 40.0,
                top: 0,
                height: 36,
                child: Container(
                    margin: const EdgeInsets.only(left: 0.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFF3F3F3),
                        ),
                        borderRadius: BorderRadius.circular(10.0), //3像素圆角
                      ),
                      child: TextField(
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "搜索产品或编号",
                          hintStyle: TextStyle(
                              fontSize: 12.0, color: Color(0xFFcccccc)),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFFcccccc),
                          ),
                          contentPadding: EdgeInsets.all(3.0),
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    )),
              ),
              Positioned(
                left: 0.0,
                top: 40,
                right: 0,
                height: 31,
                child: Opacity(
                  opacity: 0.6,
                  child: ClipRRect(
                    //剪裁为圆角矩形
                    borderRadius: BorderRadius.circular(0.0),
                    child: Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: Text(
                        "蓝牙未打开",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  left: 0.0,
                  top: 71,
                  bottom: 0,
                  width: 80,
                  child: Container(
                      color: Color(0xFFF8F8F8),
                      child: ListView.separated(
                        itemCount: bloc.words.length,
                        itemBuilder: (context, index) {
                          //如果到了表尾
                          if (bloc.words[index].sortName == bloc.loading) {
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
                          return IconButton(
                            padding: EdgeInsets.all(0.0),
                            icon: Container(
                              color: bloc.index == index
                                  ? Color(0xFFFFFFFF)
                                  : Color(0xFFF8F8F8),
                              padding: EdgeInsets.all(0.0),
                              //width: 88,
                              height: 53,
                              //容器内补白
                              //color: Colors.black,
                              alignment: Alignment.center,
                              child: Text(bloc.words[index].sortName,
                                  style: TextStyle(
                                    color: bloc.index == index
                                        ? Color(0xFF0079FE)
                                        : Color(0xFFA2A2A6),
                                    fontSize: 14,
                                    fontWeight: bloc.index == index
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  )),
                            ),
                            onPressed: () {
                              bloc.onToDetails(index);
                            }, //点击
                          );
                        },
                        separatorBuilder: (context, index) => Container(
                          height: 1,
                          color: Color(0xFFF3F3F3),
                        ),
                      ))),
//              Positioned(
//                left: 80.0,
//                top: 71,
//                bottom: 0,
//                width: 1,
//                child: Container(
//                  color: Color(0xFFEBEBEB),
//                ),
//              ),
              Positioned(
                  left: 80.0,
                  top: 71,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.white,
                    child: GridView.count(
                      ///水平子Widget之间间距/
                      crossAxisSpacing: 10.0,

                      ///垂直子Widget之间间距/
                      mainAxisSpacing: 10.0,

                      ///GridView内边距/
                      padding: EdgeInsets.only(top: 20.0, left: 10, right: 10),

                      ///一行的Widget数量/
                      crossAxisCount: 3,

                      ///子Widget宽高比例/
                      childAspectRatio: 1.0,

                      ///子Widget列表/
                      children: bloc.words[bloc.index].model
                          .map((item) => getItemContainer(item))
                          .toList(),
                    ),
                  )
//                Container(
//                  color: Colors.white,
//                  margin: const EdgeInsets.only(left: 0.0, right: 0.0),
////                  padding: const EdgeInsets.only(top: 30.0),
//                  child: new StaggeredGridView.countBuilder(
//                    crossAxisCount: 4,
//                    itemCount: 6,
//                    itemBuilder: (BuildContext context, int index) =>
//                        new Container(
//                            child: new Container(
//                                child: Container(
//                      margin: index.isEven
//                          ? const EdgeInsets.only(left: 15)
//                          : const EdgeInsets.only(right: 15),
//                      child: DecoratedBox(
//                          decoration: BoxDecoration(
//                            //color: Color(0xFF000000),
//                            borderRadius: BorderRadius.circular(0.0),
////                                    border: Border.all(
////                                        color: Color(0xFF3578F7)),
//                          ),
//                          child: Stack(
//                            alignment: Alignment.center,
//                            //指定未定位或部分定位widget的对齐方式
//                            children: <Widget>[
//                              Flex(
//                                direction: Axis.vertical,
//                                children: <Widget>[
//                                  Image(
//                                    image: AssetImage("assets/yizi.png"),
//                                    width: 36.0,
//                                    height: 36.0,
//                                  ),
//                                  Container(
//                                    child: Text("SL-A100",
//                                        maxLines: 1,
//                                        overflow: TextOverflow.ellipsis,
//                                        textAlign: TextAlign.center,
//                                        style: TextStyle(
//                                          color: Color(0xFF999999),
//                                          fontSize: 10,
//                                        )),
//                                  ),
//                                  Expanded(
//                                    flex: 1,
//                                    child: Container(
//                                      child: Text("AI太空椅",
//                                          maxLines: 1,
//                                          overflow: TextOverflow.ellipsis,
//                                          textAlign: TextAlign.center,
//                                          style: TextStyle(
//                                            color: Color(0xFF666666),
//                                            fontSize: 10,
//                                          )),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ],
//                          )),
//                    ))),
//                    staggeredTileBuilder: (int index) =>
//                        new StaggeredTile.count(2, 1.2),
//                    mainAxisSpacing: 15.0,
//                    crossAxisSpacing: 15.0,
//                  ),
//                ),
                  ),
            ],
          ),
        ),
      ),
//
    );
  }

  Widget getItemContainer(DeviceModel item) {
    return Stack(
      alignment: Alignment.center,
      //指定未定位或部分定位widget的对齐方式
      children: <Widget>[
        Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Container(
              //color: Color(0xFFF8F8F8),
              child: Image.network(
                item.modelIcon,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
//            Container(
//              margin: EdgeInsets.only(top: 5),
//              child: Text("SL-A100",
//                  maxLines: 1,
//                  overflow: TextOverflow.ellipsis,
//                  textAlign: TextAlign.center,
//                  style: TextStyle(
//                    color: Color(0xFF999999),
//                    fontSize: 12,
//                  )),
//            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(item.modelName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFA2A2A6),
                      fontSize: 12,
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
