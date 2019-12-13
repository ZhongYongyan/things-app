import 'package:app/module/guide/GuideBloc.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class GuidePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<GuidePage, GuideBloc> {
  @override
  GuideBloc createBloc(Store<StoreState> store) {
    return GuideBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    bloc.w = MediaQuery.of(context).size.width;
    Widget body = _pageBody();
    return body;
  }

  _pageBody() {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: PageView.custom(
        childrenDelegate: new SliverChildBuilderDelegate(
          (context, index) {
            return new Center(
              child: Stack(
                alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
                children: <Widget>[
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0,
                    bottom: 0,
                    child: Image(
                      image: _screenImage(index),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 125,
                    child: Text(bloc.textList[index],
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  index == 3
                      ? Positioned(
                    bottom:50,
                          //height: bloc.w * 1.12,
                          child: ClipRRect(
                            //剪裁为圆角矩形
                            borderRadius: BorderRadius.circular(23.0),
                            child: GestureDetector(
                              child: Container(
                                width: 182,
                                height: 46,
                                alignment: Alignment.center,
                                color: Color(0xFF0079FE),
                                child: Text("立即体验",
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 16,
                                    )),
                              ),
                              onTap: () => bloc.to(),
                            ),
                          ),
                        )
                      : Container(),
                  index != 3 ?  Positioned(
                      bottom: 70,
                      child:
                          Flex(direction: Axis.horizontal, children: <Widget>[
                        Padding(
                          //左边添加8像素补白
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: ClipOval(
                              child: Container(
                            width: 9,
                            height: 9,
                            color: index == 0
                                ? Color(0xFF52C1F5)
                                : Color(0xFF666666),
                          )),
                        ),
                        Padding(
                          //左边添加8像素补白
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: ClipOval(
                              child: Container(
                            width: 9,
                            height: 9,
                            color: index == 1
                                ? Color(0xFF52C1F5)
                                : Color(0xFF666666),
                          )),
                        ),
                        Padding(
                          //左边添加8像素补白
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: ClipOval(
                              child: Container(
                            width: 9,
                            height: 9,
                            color: index == 2
                                ? Color(0xFF52C1F5)
                                : Color(0xFF666666),
                          )),
                        ),
                        Padding(
                          //左边添加8像素补白
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: ClipOval(
                              child: Container(
                            width: 9,
                            height: 9,
                            color: index == 3
                                ? Color(0xFF52C1F5)
                                : Color(0xFF666666),
                          )),
                        ),
                      ])) : Container(),
                ],
              ),
            );
          },
          childCount: 4,
        ),
      ),
    );
  }

  ImageProvider _screenImage(index) {
    int i = index % 2;
    return AssetImage('assets/bg_images.png');
  }
}
