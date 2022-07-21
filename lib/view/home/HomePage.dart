import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/noripple.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/home/HomeBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:redux/src/store.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<HomePage, HomeBloc> {
  static const loadingTag = "##loading##"; //表尾标记
  var _words = <String>[loadingTag];

  @override
  void initState() {
    // bloc.getBanner();
    super.initState();
  }

  @override
  HomeBloc createBloc(Store<StoreState> store) {
    return HomeBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    print(
        'jfaslkdfjlakdjaklfjalfjaskdlfjadlk;sfja;fdjasdghakdjfalfkajlsd;fjakdsfja;dfk');
    Widget body = _pageBody(context);
    return body;
  }

  // _pageBody() {
  //   return Scaffold(
  //     backgroundColor: Color(0xFFf8f8f8),
  //     body: ScrollConfiguration(
  //       behavior: MyBehavior(),
  //       // 显示进度条
  //       child: Container(
  //         child: ConstrainedBox(
  //           constraints: BoxConstraints.expand(),
  //           child: Stack(
  //             alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
  //             children: <Widget>[
  //               Positioned(
  //                 left: 10.0,
  //                 top: 0,
  //                 right: 10.0,
  //                 bottom: 0,
  //                 child: Container(
  //                   color: Color(0xFFf8f8f8),
  //                 ),
  //               ),
  //               Positioned(
  //                 left: 0.0,
  //                 top: 0,
  //                 right: 0,
  //                 bottom: 0,
  //                 child: Container(
  //                   margin: EdgeInsets.all(15.0),
  //                   child: StaggeredGridView.countBuilder(
  //                     crossAxisCount: 4,
  //                     itemCount: 2 + bloc.DeviceVoModel.devices.length,
  //                     itemBuilder: (BuildContext context, int index){
  //                       if(bloc.indexInit){
  //                         bloc.getBanner();
  //                       }
  //                       return Container(
  //                           child: Container(
  //                               child: index == 0
  //                                   ? AspectRatio(
  //                                   aspectRatio: 16/7,
  //                                   child: Swiper(
  //                                     containerWidth: 360,
  //                                     containerHeight: 158,
  //                                     itemBuilder: (BuildContext context, int index) {
  //
  //                                       return Container(
  //                                         margin: const EdgeInsets.fromLTRB(5,0,5,0),
  //                                         constraints: BoxConstraints(minHeight: 158,minWidth: 360),
  //                                         child:ClipRRect(
  //                                           //剪裁为圆角矩形
  //                                           borderRadius: BorderRadius.circular(15.0),
  //                                           child: Image.network(
  //                                             bloc.banners[index].imageurl,
  //                                             fit:BoxFit.fill,
  //                                           ),
  //                                         ),
  //                                       );
  //                                     },
  //                                     autoplay: true,
  //                                     duration: 70,
  //                                     autoplayDelay: 5000,
  //                                     itemCount: bloc.banners.length,
  //                                     pagination: new SwiperPagination(
  //                                         builder:DotSwiperPaginationBuilder(
  //                                             activeColor: Color(0xFF0079FE)
  //                                         )
  //                                     ),
  //                                     indicatorLayout: PageIndicatorLayout.COLOR,
  //                                   )
  //                               )
  //                                   : index == 1
  //                                   ? getUserItem(index)
  //                                   : getCardItem(index)));
  //                     },
  //                     staggeredTileBuilder: (int index) => index == 0
  //                         ? new StaggeredTile.fit(4)
  //                         : index == 1
  //                         ? new StaggeredTile.fit(4)
  //                         : new StaggeredTile.count(2, 1.1),
  //                     mainAxisSpacing: 15.0,
  //                     crossAxisSpacing: 15.0,
  //                   ),
  //                 ),
  //               ),
  //               bloc.loadShow
  //                   ? Positioned(
  //                   left: 0,
  //                   top: 0,
  //                   right: 0,
  //                   bottom: 0,
  //                   child: Container(
  //                     padding: const EdgeInsets.all(0),
  //                     alignment: Alignment.center,
  //                     child: SizedBox(
  //                         width: 24.0,
  //                         height: 24.0,
  //                         child: CircularProgressIndicator(strokeWidth: 2.0)),
  //                   ))
  //                   : Container()
  //             ],
  //           ),
  //         ),
  //       )
  //     ),
  //   );
  // }

  //用户信息及设置
  Widget getUserItem(int index) {
    return Card(
        key: ValueKey('A'),
        margin: EdgeInsets.only(top: 20, bottom: 20),
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getText(bloc.homeAdd, 18.0, Color(0xFF666666)),
                      getText(
                          bloc.homeAddExplain + '...', 16.0, Color(0xFF999999))
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Icon(
                    Icons.add_circle_outline_outlined,
                    color: Color(0xFF666666),
                    size: 40,
                  ),
                  onTap: () => bloc.add(),
                ),
              ),
              Container(
                child: GestureDetector(
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: Color(0xFFBBBBBB),
                    size: 40,
                  ),
                  // onTap: () => bloc.toDeleteDevice(),
                ),
              ),
            ],
          ),
        ));
  }

  //官方微信
  Widget officialWeChat() {
    return Card(
        key: ValueKey('B'),
        margin: EdgeInsets.only(top: 20, bottom: 20),
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            height: 100,
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getText(bloc.learnMore, 18.0, Color(0xFF666666)),
                      getText(bloc.officialWeChat, 12.0, Color(0xFFFF9267))
                    ],
                  ),
                )),
                Image.network(
                    'https://axhub.im/ax9/7daa3ef63e5c1293/images/首页/u338.png',
                    fit: BoxFit.cover)
              ],
            ),
          ),
          onTap: _modelBottom,
        ));
  }

  _pageBody(context) {
    if (bloc.indexInit) {
      bloc.getBanner();
      return Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0)),
          ));
    }
    return Scaffold(
      backgroundColor: Color(0xFFf8f8f8),
      body: SafeArea(
        child: ScrollConfiguration(
            behavior: MyBehavior(),
            // 显示进度条
            child: Container(
              margin: EdgeInsets.all(20),
              color: Color(0xFFf8f8f8),
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Column(
                  children: [
                    Container(
                      child: AspectRatio(
                          aspectRatio: 16 / 7,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            bloc.banners[index].imageurl),
                                        fit: BoxFit.cover)),
                                // child: Image.network(bloc.banners[index].imageurl,
                                //     fit:BoxFit.fill),
                              );
                            },
                            autoplay: true,
                            duration: 500,
                            autoplayDelay: 3000,
                            itemCount: bloc.banners.length,
                            pagination: SwiperPagination(
                                builder: DotSwiperPaginationBuilder(
                                    activeColor: Colors.white,
                                    color: Color.fromRGBO(169, 154, 142, 0.6))),
                            // indicatorLayout: PageIndicatorLayout.COLOR,
                          )),
                    ),

                    getUserItem(1),
                    // getCardItem(2),
                    officialWeChat(),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  //单个设备
  Widget getCardItem(int index) {
    return GestureDetector(
      onTap: () => bloc.toPlugin(index),
      onLongPress: () => bloc.updateOnLongPressStatus(index, true),
      child: Container(
        margin: index.isEven
            ? const EdgeInsets.only(left: 15)
            : const EdgeInsets.only(right: 15),
        child: DecoratedBox(
            decoration: BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //设置四周边框
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                )
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              //指定未定位或部分定位widget的对齐方式
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    //左边添加8像素补白
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              direction: Axis.vertical,
                              children: <Widget>[
                                getExpanded(bloc.devicesName, 0),
                                getExpanded(
                                    bloc.findModelName(bloc.DeviceVoModel
                                        .devices[index - 2].modelId),
                                    1),
//                                  getExpanded(
//                                      bloc.findSortName(bloc.DeviceVoModel
//                                          .devices[index - 2].sortId),
//                                      1),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Flex(
                              direction: Axis.vertical,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 13, left: 20),
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
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 15, left: 20),
                                        width: 7.95,
                                        height: 7.95,
                                        decoration: new BoxDecoration(
                                          //背景
                                          color: bloc
                                                      .DeviceVoModel
                                                      .devices[index - 2]
                                                      .statusCode ==
                                                  "ONLINE"
                                              ? const Color(0xFF1BCB4D)
                                              : const Color(0xFFFF3B3B),
                                          //设置四周圆角 角度
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(90.0)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: bloc
                                                          .DeviceVoModel
                                                          .devices[index - 2]
                                                          .statusCode ==
                                                      "ONLINE"
                                                  ? const Color(0x6600E15A)
                                                  : const Color(0x66FF3B3B),
                                              spreadRadius: 1,
                                              blurRadius: 2.0,
                                            )
                                          ],
                                        ),
                                        /*child: Image(
                                            image: bloc
                                                        .DeviceVoModel
                                                        .devices[index - 2]
                                                        .statusCode ==
                                                    "ONLINE"
                                                ? AssetImage("assets/ok.png")
                                                : AssetImage("assets/on.png"),
                                            width: 16.0,
                                            height: 16.0,
                                          ),*/
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 12, left: 32),
                                        child: Text(
                                            bloc
                                                        .DeviceVoModel
                                                        .devices[index - 2]
                                                        .statusCode ==
                                                    "ONLINE"
                                                ? bloc.onLine
                                                : bloc.offLine,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Color(0xFF3D3D3D),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w100,
                                            )),
                                      ),
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
                bloc.DeviceVoModel.devices[index - 2].loadShow &&
                        !bloc.DeviceVoModel.devices[index - 2].isDelete
                    ? Container(
                        width: 150,
                        height: 88,
                        color: Colors.white.withOpacity(0.84),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            //设置四周圆角 角度
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Stack(
                            alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
                            children: <Widget>[
                              Positioned(
                                top: 17.5,
                                child: Text(
                                  !bloc.findIsDownloading(bloc.DeviceVoModel
                                          .devices[index - 2].modelId)
                                      ? bloc.downloadNewPlugIns
                                      : bloc.plugInDownloading,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF3D3D3D),
                                  ),
                                ),
                              ),
                              !bloc.findIsDownloading(bloc
                                      .DeviceVoModel.devices[index - 2].modelId)
                                  ? Positioned(
                                      top: 50,
                                      child: GestureDetector(
                                          onTap: () => bloc.toDownload(index),
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  //设置四周圆角 角度
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                ),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    width: 68,
                                                    height: 27,
                                                    child: Text(
                                                      bloc.update,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    )),
                                              ))))
                                  : Positioned(
                                      top: 50,
                                      child: Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        alignment: WrapAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 40,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 3),
                                              child: SpinKitThreeBounce(
                                                color: Colors.blue,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                bloc.DeviceVoModel.devices[index - 2].isDelete
                    ? Container(
                        width: 150,
                        height: 88,
                        color: Colors.white.withOpacity(0.84),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            //设置四周圆角 角度
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Stack(
                            alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
                            children: <Widget>[
                              Positioned(
                                top: 17.5,
                                child: Text(
                                  bloc.confirmDeletionTips,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF3D3D3D),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 50,
                                child: Wrap(
                                  spacing: 8,
                                  children: <Widget>[
                                    Container(
                                        child: GestureDetector(
                                            onTap: () =>
                                                bloc.toDeleteDevice(index),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    //设置四周圆角 角度
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  ),
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 50,
                                                      height: 24,
                                                      child: Text(
                                                        bloc.delete,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      )),
                                                )))),
                                    Container(
                                        child: GestureDetector(
                                            onTap: () =>
                                                bloc.updateOnLongPressStatus(
                                                    index, false),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    //设置四周圆角 角度
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  ),
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 50,
                                                      height: 24,
                                                      child: Text(
                                                        bloc.cancel,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      )),
                                                )))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            )),
      ),
    );
  }

  Widget getText(String text, double fs, Color color) {
    return Text(text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: TextStyle(color: color, fontSize: fs, height: 1.5));
  }

  Widget getExpanded(String text, int start) {
    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.topLeft,
        margin: start == 0
            ? const EdgeInsets.only(left: 6, top: 14)
            : const EdgeInsets.only(left: 6, top: 8),
        child: Text(text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Color(0xFF3D3D3D),
              fontWeight: start == 0 ? FontWeight.w600 : FontWeight.w300,
              fontSize: start == 0 ? 16 : 12,
              fontFamily: "PingFang-SC-Bold",
            )),
      ),
    );
  }

  //弹出层,显示官方公众号二维码
  void _modelBottom() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context1, state) {
          return Container(
            margin: EdgeInsets.only(top:80, bottom:80),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left:30, right:30),
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: (){
                        state(() {
                          bloc.showWeChatOptionButton = false;
                        });
                        Navigator.pop(context1);
                      },
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Colors.white,
                        size: 40,
                      )),
                ),
                Expanded(
                    child: InkWell(
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(50, 20, 50, 20),
                      padding: EdgeInsets.fromLTRB(30, 60, 30, 60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, 1.0),
                            colors: [
                              Color(0xFF2681ff),
                              Color.fromRGBO(12, 41, 83, 1)
                            ]),
                      ),
                      child: Column(
                        children: [
                          Text('IREST',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(bloc.recognizeCode,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          Text(bloc.officialWeChat,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          SizedBox(height: 20),
                          Image.network(
                              'https://axhub.im/ax9/7daa3ef63e5c1293/images/首页/u337.png',
                              fit: BoxFit.cover)
                        ],
                      ),
                    ),
                    onLongPress: () {
                      state(() {
                        bloc.showWeChatOptionButton = true;
                      });
                    },
                )),
                Opacity(
                  opacity: bloc.showWeChatOptionButton ? 1 : 0,
                  child: Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    child: Column(
                      children: [
                        _actionButton(bloc.toFriends,2,state),
                        _actionButton(bloc.saveToPhone,1,state),
                        _actionButton(bloc.cancel,0,state,context1)
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }); //showModalBottomSheet相当于打开一个新的页面，所以不可直接使用setData更新它里面的数据，需要包裹上StatefulBuilder并创建一个新的setData方法，即state
      },
    );
  }

  //操作按钮
  Widget _actionButton(String text,int type,Function state,[BuildContext context1]) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
              begin: Alignment(0.0, -1.0),
              end: Alignment(0.0, 1.0),
              colors: [Color.fromRGBO(12, 41, 83, 1), Color(0xFF2681ff)]),
        ),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 17)),
      ),
      onTap: (){
        if(type==0){
          state(() {
            bloc.showWeChatOptionButton = false;
          });
          Navigator.pop(context1);
        }
      },
    );
  }

  bool get wantKeepAlive => false;
}
