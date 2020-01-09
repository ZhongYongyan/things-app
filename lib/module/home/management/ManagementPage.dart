import 'package:app/module/home/management/ManagementBloc.dart';
import 'package:app/module/home/user/component/UsercomPage.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/src/store.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
      body:SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(
            alignment:Alignment.center , //指定未定位或部分定位widget的对齐方式
            children: <Widget>[

            Positioned(
              left: 5.0,
              top: 0,
              height: 36,
              child: Container(
                child:IconButton(
                  icon: Container(
                    margin: const EdgeInsets.only(
                        top: 2.0),
                    child: Image(
                      image: AssetImage(
                          "assets/back.png"),
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
                        style: TextStyle(
                            fontSize: 14.0, color: Colors.black),
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
            child:Opacity(
              opacity: 0.6,
              child: ClipRRect(
                //剪裁为圆角矩形
                borderRadius:
                BorderRadius
                    .circular(
                    0.0),
                child:
                Container(
                  color: Colors
                      .black,
                ),
              ),
            ),
          ),
              Positioned(
                left: 0.0,
                top: 71,
                bottom: 0,
                width: 80,
                child: ListView(
                    scrollDirection: Axis.vertical,
                    children: bloc.textList
                    //每一个字母都用一个Text显示,字体为原来的两倍
                        .map(
                          (t) => GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(0.0),
                          //width: 88,
                          height: 53,//容器内补白
                          //color: Colors.black,
                          alignment: Alignment.center,
                          child: Text(t,
                              style: TextStyle(
                                color: bloc.text == t
                                    ? Color(0xFF3578F7)
                                    : Color(0xFF666666),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                        onTap: () => bloc.to(), //点击
                      ),
                    )
                        .toList(),
                )
              ),
          Positioned(
            left: 80.0,
            top: 71,
            bottom: 0,
            width: 1,
            child:Container(
              color: Color(0xFFEBEBEB),
            ) ,
          ),
              Positioned(
                left: 81.0,
                top: 71,
                right: 0,
                bottom: 0,
                child: Container(
                  margin: const EdgeInsets.only(left: 0.0, right: 0.0),
//                  padding: const EdgeInsets.only(top: 30.0),
                  child: new StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    itemCount: 6,
                    itemBuilder: (BuildContext context, int index) =>
                    new Container(
                        child: new Container(
                            child: Container(
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
                                        0.0),
//                                    border: Border.all(
//                                        color: Color(0xFF3578F7)),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    //指定未定位或部分定位widget的对齐方式
                                    children: <Widget>[
                                      Flex(
                                        direction: Axis.vertical,
                                        children: <Widget>[
                                          Image(
                                            image: AssetImage(
                                                "assets/yizi.png"),
                                            width:
                                            36.0,
                                            height:
                                            36.0,
                                          ),

                                          Container(
                                            child: Text(
                                                "SL-A100",
                                                maxLines:
                                                1,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF999999),
                                                  fontSize: 10,
                                                )),

                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: Text(
                                                  "AI太空椅",
                                                  maxLines:
                                                  1,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xFF666666),
                                                    fontSize: 10,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),


                                    ],
                                  )),
                            ))),
                    staggeredTileBuilder: (int index) => new StaggeredTile.count(2, 1.2),

                    mainAxisSpacing: 15.0,
                    crossAxisSpacing: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
//
    );
  }
}
