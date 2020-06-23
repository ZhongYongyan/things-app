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

  _pageBody() {
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
                    itemCount: 2 + bloc.DeviceVoModel.devices.length,
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
                                        ? getUserItem(index)
                                        : getCardItem(index))),
                    staggeredTileBuilder: (int index) => index == 0
                        ? new StaggeredTile.fit(4)
                        : index == 1
                            ? new StaggeredTile.fit(4)
                            : new StaggeredTile.count(2, 1.1),
                    mainAxisSpacing: 15.0,
                    crossAxisSpacing: 15.0,
                  ),
                ),
              ),
              bloc.loadShow
                  ? Positioned(
                      left: 0,
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        alignment: Alignment.center,
                        child: SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CircularProgressIndicator(strokeWidth: 2.0)),
                      ))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  //用户信息及设置
  Widget getUserItem(int index) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
      //color: Color(0xFF3578F7),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.vertical,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                      right: 5,
                    ),
                    child: ClipOval(
                        child: bloc.url != ""
                            ? Image.network(
                                bloc.url,
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              )
                            : bloc.name == "访客"
                                ? Image(
                                    image: AssetImage("assets/visitor.jpeg"),
                                    fit: BoxFit.cover,
                                    width: 30,
                                    height: 30,
                                  )
                                : Image(
                                    image: AssetImage("assets/home_y.png"),
                                    fit: BoxFit.cover,
                                    width: 30,
                                    height: 30,
                                  )),
                  ),
                  GestureDetector(
                    child: Text(bloc.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF3578F7),
                          fontSize: 16,
                        )),
                    onTap: () => bloc.to(), //点击
                  ),
                  GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Icon(Icons.keyboard_arrow_down,
                          color: Color(0xFF3578F7)),
                    ),
                    onTap: () => bloc.to(), //点击
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
              ),
              getText("点击右侧「添加设备"),
              getText("连接智能设备"),
              getText("体验美好生活")
            ],
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Container(
            width: 51,
            height: 51,
            child: GestureDetector(
              child: ClipOval(
                child: Container(
                  width: 51,
                  height: 51,
                  color: Color(0xFF3578F7),
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
    );
  }

  //单个设备
  Widget getCardItem(int index) {
    return GestureDetector(
        onTap: () => bloc.toPlugin(index),
        child: Container(
          margin: index.isEven
              ? const EdgeInsets.only(left: 15)
              : const EdgeInsets.only(right: 15),
          child: DecoratedBox(
              decoration: BoxDecoration(
                //color: Color(0xFF000000),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Color(0xFF3578F7)),
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
                      padding: const EdgeInsets.all(10.0),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Flex(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                direction: Axis.vertical,
                                children: <Widget>[
                                  getExpanded("设备名称", 0),
                                  getExpanded(
                                      bloc.findModelName(bloc.DeviceVoModel
                                          .devices[index - 2].modelId),
                                      1),
                                  getExpanded(
                                      bloc.findSortName(bloc.DeviceVoModel
                                          .devices[index - 2].sortId),
                                      1),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Flex(
                                direction: Axis.vertical,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    //color: Color(0xFFF8F8F8),
                                    child: Image.network(
                                      bloc.findModelIcon(bloc.DeviceVoModel
                                          .devices[index - 2].modelId),
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(
                                            right: 5,
                                          ),
                                          child: Image(
                                            image: bloc
                                                        .DeviceVoModel
                                                        .devices[index - 2]
                                                        .statusCode ==
                                                    "ONLINE"
                                                ? AssetImage("assets/ok.png")
                                                : AssetImage("assets/on.png"),
                                            width: 13.0,
                                            height: 13.0,
                                          ),
                                        ),
                                        Text(
                                            bloc
                                                        .DeviceVoModel
                                                        .devices[index - 2]
                                                        .statusCode ==
                                                    "ONLINE"
                                                ? "在线"
                                                : '离线',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: bloc
                                                          .DeviceVoModel
                                                          .devices[index - 2]
                                                          .statusCode ==
                                                      "ONLINE"
                                                  ? Color(0xFF3578F7)
                                                  : Color(0xFFCDCDCD),
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
                ],
              )),
        ));
  }

  Widget getText(String text) {
    return Text(text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: TextStyle(color: Color(0xFF333333), fontSize: 15, height: 1.5));
  }

  Widget getExpanded(String text, int start) {
    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Text(text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: start == 0 ? Color(0xFF3578F7) : Color(0xFF9CC5FF),
              fontSize: start == 0 ? 16 : 12,
            )),
      ),
    );
  }

  bool get wantKeepAlive => false;
}
