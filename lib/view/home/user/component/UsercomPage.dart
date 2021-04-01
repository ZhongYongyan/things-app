import 'dart:io';

import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/home/user/component/UsercomBloc.dart';
import 'package:app/view/home/user/component/lib/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

import 'ActionSheet.dart';
//import 'package:image_picker/image_picker.dart';

class UsercomPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<UsercomPage, UsercomBloc> {
  @override
  UsercomBloc createBloc(Store<StoreState> store) {
    return UsercomBloc(context, store)..startup();
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
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(alignment: Alignment.topLeft, //指定未定位或部分定位widget的对齐方式
              children: <Widget>[
                Container(
                  color: Color(0xFFF9F9F9),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bloc.words.length,
                    itemBuilder: (context, index) {
                      //如果到了表尾
                      if (bloc.words[index] == bloc.loading) {
                        //不足100条，继续获取数据
                        if (bloc.words.length - 1 < 6) {
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  //height: 100,
                                  child: Padding(
                                    //左边添加8像素补白
                                    padding: index == 0
                                        ? const EdgeInsets.only(
                                            left: 15.0, right: 10, top: 11)
                                        : const EdgeInsets.only(
                                            left: 15.0, right: 10, top: 13.5),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      children: <Widget>[
                                        index == 0
                                            ? ClipOval(
                                                child: bloc.imgPath != ""
                                                    ? new Image.file(
                                                        File(bloc.imgPath),
                                                        width: 48,
                                                        height: 48,
                                                        fit: BoxFit.cover)
                                                    : Image.network(
                                                        'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
                                                        width: 48,
                                                        height: 48,
                                                        //fit: BoxFit.cover,
                                                      ),
                                              )
                                            : Container(),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Container(
                                              child: index != 0
                                                  ? Text(bloc.textList[index],
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
                                                      ))
                                                  : Text(''),
                                            ),
                                          ),
                                        ),
                                        index == 1
                                            ? Container(
                                                //height: 20,
                                                alignment:
                                                    Alignment.centerRight,
                                                width: 80,
                                                child: TextFormField(
                                                  textAlign: TextAlign.right,
                                                  controller:
                                                      bloc.usernameController,
//                                                focusNode: bloc.usernameFocus,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black),
                                                  autocorrect: false,
                                                  decoration: InputDecoration(
                                                    hintText: '点击填写',
                                                    border: InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.all(0.0),
                                                    hintStyle: false
                                                        ? TextStyle(
                                                            fontSize: 14.0,
                                                            color: Color(
                                                                0xFFEC4D5C))
                                                        : TextStyle(
                                                            fontSize: 14.0,
                                                            color: Color(
                                                                0xFFcccccc)),
                                                  ),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      //bloc.phoneisEmpty = true;
                                                    } else {
                                                      //bloc.phoneisEmpty = false;
                                                    }
                                                  },
                                                ),
                                              )
                                            : index == 3
                                                ? Container(
                                                    //height: 20,
                                                    alignment:
                                                        Alignment.centerRight,
                                                    width: 80,
                                                    child: TextFormField(
                                                      textAlign:
                                                          TextAlign.right,
                                                      controller:
                                                          bloc.heightController,
//                                                focusNode: bloc.usernameFocus,
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black),
                                                      autocorrect: false,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: '点击填写',
                                                        border:
                                                            InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.all(0.0),
                                                        hintStyle: false
                                                            ? TextStyle(
                                                                fontSize: 14.0,
                                                                color: Color(
                                                                    0xFFEC4D5C))
                                                            : TextStyle(
                                                                fontSize: 14.0,
                                                                color: Color(
                                                                    0xFFcccccc)),
                                                      ),
                                                      validator: (value) {
                                                        if (value.isEmpty) {
                                                          //bloc.phoneisEmpty = true;
                                                        } else {
                                                          //bloc.phoneisEmpty = false;
                                                        }
                                                      },
                                                    ),
                                                  )
                                                : index == 4
                                                    ? Container(
                                                        //height: 20,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        width: 80,
                                                        child: TextFormField(
                                                          textAlign:
                                                              TextAlign.right,
                                                          controller: bloc
                                                              .weightController,
//                                                focusNode: bloc.usernameFocus,
                                                          style: TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  Colors.black),
                                                          autocorrect: false,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: '点击填写',
                                                            border: InputBorder
                                                                .none,
//                                              prefixIcon: Icon(
//                                                Icons.phone_iphone,
//                                                color: Color(0xFFcccccc),
//                                              ),
                                                            disabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
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
                                                          validator: (value) {
                                                            if (value.isEmpty) {
                                                              //bloc.phoneisEmpty = true;
                                                            } else {
                                                              //bloc.phoneisEmpty = false;
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    : Text(bloc.userList[index],
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF333333),
                                                          fontSize: 14,
                                                          //height: 1.6
                                                          //fontWeight:FontWeight.w700,
                                                        )),
                                        index == 0 || index == 2 || index == 5
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5),
                                                child: Icon(Icons.navigate_next,
                                                    color: Color(0xFFCCCCCC)),
                                              )
                                            : Container(
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        onTap: () => {
                          if (index == 0)
                            {
                              BottomActionSheet.show(context, ['拍照', '相册'],
                                  title: '', callBack: (i) {
                                if (i == 0) {
                                  bloc.takePhoto();
                                }
                                if (i == 1) {
                                  bloc.openGallery();
                                }
                                return;
                              }),
                            },
                          if (index == 2)
                            {
                              BottomActionSheet.show(context, ['男', '女'],
                                  title: '', callBack: (i) {
                                if (i == 0) {
                                  bloc.userClick('男');
                                }
                                if (i == 1) {
                                  bloc.userClick('女');
                                }
                                return;
                              }),
                            },
                          if (index == 5)
                            {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  onChanged: (date) {}, onConfirm: (date) {
                                bloc.click('$date');
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
              ]),
        ),
      ),
    );
  }
}
