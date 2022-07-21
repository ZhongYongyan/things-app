import 'dart:convert';
import 'dart:io';

import 'package:app/base/util/BlocUtils.dart';
import 'package:app/component/PickerPopup.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/home/user/component/ActionSheet.dart';
import 'package:app/view/home/user/component/lib/flutter_datetime_picker.dart';
import 'package:app/view/home/user/component/lib/src/i18n_model.dart';
import 'package:app/view/home/user/details/DatailsBloc55.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/src/store.dart';

class UserDatailsPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<UserDatailsPage, DatailsBloc> {
  @override
  DatailsBloc createBloc(Store<StoreState> store) {
    return DatailsBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map;
    var model = args["model"];
    bloc.affiliateModel = model;
    bloc.setUI();
    Widget body = _pageBody();
    return body;
  }

  _pageBody() {
    return Scaffold(
        key: bloc.scaffoldKey,
        appBar: AppBar(
          //导航栏
          elevation: 0,
          brightness: Brightness.light,
          centerTitle: true,
          leading: new IconButton(
            icon: new Container(
              padding: EdgeInsets.all(0.0),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 0),
                child: new Text(bloc.back,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF0079FE), fontSize: 14)),
              ),
            ),
            onPressed: () {
              bloc.toBack();
            },
          ),
          title: Text(bloc.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              )),
          actions: <Widget>[
            // 非隐藏的菜单
            new IconButton(
              icon: new Container(
                padding: EdgeInsets.all(0.0),
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 0),
                  child: new Text(bloc.preservation,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF0079FE), fontSize: 14)),
                ),
              ),
              onPressed: () {
                bloc.addAffiliate();
              },
            ),
            // 隐藏的菜单
          ],
          backgroundColor: Colors.white,
        ),
        backgroundColor: Color(0xFFF9F9F9),
        body: Container(
          child: Scrollbar(
            // 显示进度条
            child: SingleChildScrollView(
//          padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  //动态创建一个List<Widget>
                  children: <Widget>[
                    Container(
                      //width: 200,
                      height: 450,
//                  width: 375,
                      child: Container(
                        color: Color(0xFFF9F9F9),
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
                              }
                              else {
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
                                height: index == 0 ? 71 : 51,
                                margin: index == 1
                                    ? const EdgeInsets.only(top: 20)
                                    : index == 0
                                        ? const EdgeInsets.only(top: 20)
                                        : const EdgeInsets.only(top: 0),
                                alignment: Alignment.centerLeft,
                                color: Colors.white,
                                child: Column(
                                    //测试Row对齐方式，排除Column默认居中对齐的干扰
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        //height: 100,
                                        child: Padding(
                                          //左边添加8像素补白
                                          padding: index == 0  //0头像
                                              ? const EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 10,
                                                  top: 11)
                                              : index == 3 ||
                                                      index == 6   //3性别，6出生日期

                                                  ? const EdgeInsets.only(
                                                      left: 15.0,
                                                      right: 10,
                                                      top: 13.5)
                                                  : const EdgeInsets.only(
                                                      left: 15.0,
                                                      right: 10,
                                                      top: 0),
                                          child: Flex(
                                            direction: Axis.horizontal,
                                            children: <Widget>[
                                              index == 0   //0头像
                                                  ? ClipOval(
                                                      child: bloc.imgPath != ""
                                                          ? new Image.file(
                                                              File(
                                                                  bloc.imgPath),
                                                              width: 48,
                                                              height: 48,
                                                              fit: BoxFit.cover)
                                                          : bloc.userImgPath !=
                                                                  ""
                                                              ? Image.network(
                                                                  bloc.userImgPath,
                                                                  width: 48,
                                                                  height: 48,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image(
                                                                  image: AssetImage(
                                                                      "assets/home_y.png"),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: 48,
                                                                  height: 48,
                                                                ))
                                                  : Container(),
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Container(
                                                    child: index != 0
                                                        ? Text(
                                                            bloc.textList[
                                                                index],
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF333333),
                                                              fontSize: 14,
                                                              //height: 1.6
                                                              //fontWeight:FontWeight.w700,
                                                            ))
                                                        : Text(''),
                                                  ),
                                                ),
                                              ),
                                              index == 1 ||
                                                  index == 2 ||
                                                  index == 4 ||
                                                  index == 5   //1姓名、2手机、4身高、5体重
                                                  ? Container(
                                                      //height: 20,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      width: 140,
                                                      child: TextFormField(
                                                        keyboardType:index == 1 ? TextInputType.text : TextInputType.numberWithOptions(decimal: true),
                                                        textAlign:
                                                            TextAlign.right,
                                                        controller:index == 1 ?  bloc
                                                            .usernameController : index == 2 ? bloc.phoneController : index == 4 ? bloc.heightController :bloc.weightController,
//                                                focusNode: bloc.usernameFocus,
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            color:
                                                                Colors.black),
                                                        autocorrect: false,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: bloc.clickToFillIn,
                                                          border:
                                                              InputBorder.none,
                                                          disabledBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          hintStyle: false
                                                              ? TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Color(
                                                                      0xFFEC4D5C))
                                                              : TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Color(
                                                                      0xFFcccccc)),
                                                        ),
                                                        validator: (value) {},
                                                      ),
                                                    )
                                                  : Text(bloc.userList[index],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF333333),
                                                        fontSize: 14,
                                                        //height: 1.6
                                                        //fontWeight:FontWeight.w700,
                                                      )),
                                              index == 0 ||
                                                      index == 3 ||
                                                      index == 6   //0头像、3性别、6出生日期
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      child: Icon(
                                                          Icons.navigate_next,
                                                          color: Color(
                                                              0xFFCCCCCC)),
                                                    )
                                                  : Container(
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                    )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                              onTap: () => {
                                if (index != 1) {
                                  FocusScope.of(context).requestFocus(FocusNode())
                                },
                                if (index == 0)
                                  {
                                    BottomActionSheet.show(
                                        context, [bloc.camera, bloc.album], title: '',cancel: bloc.cancel,
                                        callBack: (i) {
                                      if (i == 0) {
                                        bloc.takePhoto();
                                      }
                                      if (i == 1) {
                                        bloc.openGallery();
                                      }
                                      return;
                                    }),
                                  },
                                if (index == 3)//3性别
                                  {
                                    BottomActionSheet.show(context, [bloc.male, bloc.female],
                                        title: '',cancel: bloc.cancel, callBack: (i) {
                                      if (i == 0) {
                                        bloc.userClick(bloc.male);
                                      }
                                      if (i == 1) {
                                        bloc.userClick(bloc.female);
                                      }
                                      return;
                                    }),
                                  },
                                if (index == 6)//6出生日期
                                  {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                minTime: DateTime(1900, 1, 1),
                                locale:bloc.cancel == "取消" ? LocaleType.zh : LocaleType.en,
                                        onChanged: (date) {},
                                        onConfirm: (date) {
                                      bloc.dataClick('$date');
                                    }, currentTime: DateTime.now()),
                                  },
                              }, //点击
                            );
                          },
                          separatorBuilder: (context, index) => Container(
                            height: 1,
                            color: Color(0xFFF3F3F3),
                          ),
                        ),
                      ),
                    ),
//
                    GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          height: 46,
//                    color: Color(0xFF000000))
                          child: ClipRRect(
                            //剪裁为圆角矩形
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              alignment: Alignment.center,
                              child: loginText(),
                              color: (bloc.title == bloc.userDetails &&
                                      !bloc.addAffiliateShow)
                                  ? Color(0xFFFA5251)
                                  : Color(0xFF0079FE),
                            ),
                          ),
                        ),
                        onTap: () => {
                              if (bloc.title == bloc.userDetails)
                                {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: Text(bloc.confirmDeletion,
                                              style: TextStyle(fontSize: 16)),
                                          content: Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(bloc.confirmDeletionTips),
                                          ),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                              child: Text(bloc.cancel),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            CupertinoDialogAction(
                                              child: Text(bloc.determine),
                                              onPressed: () {
                                                bloc.delAffiliate();
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      })
                                }
                              else
                                {bloc.addAffiliate()}
                            })
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget loginText() {
    return bloc.loginProcessing
        ? Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 40,
                child: Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: SpinKitThreeBounce(
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              Text(
                (bloc.title == bloc.userDetails && !bloc.addAffiliateShow)
                    ? bloc.deletes
                    : bloc.preservation,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ],
          )
        : Text(
            (bloc.title == bloc.userDetails && !bloc.addAffiliateShow) ? bloc.delete : bloc.preservation,
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          );
  }
}
