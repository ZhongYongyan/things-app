import 'dart:io';

import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/home/user/component/ActionSheet.dart';
import 'package:app/view/home/user/component/lib/flutter_datetime_picker.dart';
import 'package:app/view/home/user/component/lib/src/i18n_model.dart';
import 'package:app/view/my/details/DetailsBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/src/store.dart';


class MyDetailsPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<MyDetailsPage, MyDetailsBloc> {
  @override
  MyDetailsBloc createBloc(Store<StoreState> store) {
    return MyDetailsBloc(context, store);
  }

  @override
  Widget createWidget(BuildContext context) {
    // var args = ModalRoute.of(context).settings.arguments as Map;
    // var model = args["model"];
    // bloc.memberInfoModel = model;
    bloc.setUI();
    bloc.labelsWidth=(MediaQuery.of(context).size.width-80)/3;//单个标签的最小宽度
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
          title: Text(bloc.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              )),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Color(0xFFF9F9F9),
        body: SafeArea(
          // color: Color(0xFFF9F9F9),
          child: SingleChildScrollView(
//          padding: EdgeInsets.all(16.0),
            child: Column(
              //动态创建一个List<Widget>
              children: <Widget>[
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bloc.textList.length,
                  itemBuilder: (context, index) {
                    //显示单词列表项
                    return GestureDetector(
                      child: Container(
                        margin: (index == 0 || index==4)//设置0和4行距离上面有间隔
                            ? const EdgeInsets.only(top: 20)
                            : const EdgeInsets.only(top: 0),
                        alignment: Alignment.centerLeft,
                        color: Colors.white,
                        child: Container(
                          height: 50,
                          child: Padding(
                            //左边添加8像素补白
                            padding: EdgeInsets.only(left: 15.0,right: 10),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Text(
                                          bloc.textList[index],
                                          maxLines: 1,
                                          overflow:TextOverflow.ellipsis,
                                          textAlign:TextAlign.left,
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 14,
                                          )),
                                    )
                                ),
                                index == 0   //0头像
                                    ? ClipOval(
                                    child: bloc.imgPath != ""
                                        ? Image.file(
                                        File(bloc.imgPath),
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover)
                                        : bloc.userImgPath !=""
                                        ? Image.network(
                                      bloc.userImgPath,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    )
                                        : Image(
                                      image: AssetImage("assets/home_y.png"),
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                    ))
                                    : index == 1 ||index == 5 ||index == 6   //1姓名、5身高、6体重
                                    ? Container(
                                        alignment:Alignment.centerRight,
                                        width: 140,
                                        child: TextField(
                                          keyboardType:index == 1 ? TextInputType.text : index == 5 ? TextInputType.number:TextInputType.numberWithOptions(decimal:true),
                                          textAlign:TextAlign.right,
                                          controller:index == 1 ?  bloc.usernameController : index == 5 ? bloc.heightController :bloc.weightController,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color:Colors.black),
                                          autocorrect: false,
                                          focusNode: index == 1 ?  bloc.usernameFocus : index == 5 ? bloc.heightFocus :bloc.weightFocus,
                                          decoration:InputDecoration(
                                            hintText: bloc.clickToFillIn,
                                            border:InputBorder.none,
                                            disabledBorder:InputBorder.none,
                                            enabledBorder:InputBorder.none,
                                            focusedBorder:InputBorder.none,
                                            // contentPadding:EdgeInsets.all(0.0),
                                            hintStyle:TextStyle(
                                                fontSize:14.0,
                                                color: Color(0xFFcccccc)),
                                          ),
                                          inputFormatters: index == 1?bloc.rule[0]:index == 5?bloc.rule[1]:bloc.rule[2],
                                        ),
                                      )
                                    : Text(bloc.userList[index],
                                        maxLines: 1,
                                        overflow:TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color:Color(0xFF333333),
                                          fontSize: 14,
                                        )),
                                index == 0||index == 3 ||index == 4 ||index == 7|| index==8   //0头像、3人脸识别、4性别、7出生日期、8个性标签
                                    ? Container(
                                        margin:EdgeInsets.only(left: 2),
                                        child: Icon(
                                            Icons.navigate_next,
                                            size:23,
                                            color: Color(0xFFCCCCCC)
                                        ),
                                )
                                    : Container(
                                        margin: EdgeInsets.only(right: 7),
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () => {
                        if (index != 1 && index != 4) {
                          FocusScope.of(context).requestFocus(FocusNode())//点击空白处收起键盘
                        },
                        if (index == 0)
                          {
                            BottomActionSheet.show(
                                context, [bloc.camera, bloc.album], title: '',cancel: bloc.cancel,
                                callBack: (i) {
                                  if (i == 0) {
                                    bloc.takePhoto();
                                  }
                                  else if (i == 1) {
                                    bloc.openGallery();
                                  }
                                  return;
                                }),
                          }
                        else if(index==3){

                        }
                        else if (index == 4)//性别
                        {
                          BottomActionSheet.show(context, [bloc.male, bloc.female],
                              title: '',cancel: bloc.cancel, callBack: (i) {
                                if (i == 0) {
                                  bloc.userClick(bloc.male);
                                }
                                else if (i == 1) {
                                  bloc.userClick(bloc.female);
                                }
                                return;
                              }),
                        }
                        else if (index == 7)//出生日期
                        {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1900, 1, 1),
                              locale:bloc.cancel == "取消" ? LocaleType.zh : LocaleType.en,
                              onChanged: (date) {},
                              onConfirm: (date) {
                                // bloc.dataClick('$date');
                              }, currentTime: DateTime.now()),
                        }else if(index==8){
                          bloc.chooseLabels(),
                        },
                      }//点击
                    );
                  },
                  separatorBuilder: (context, index) => Container(
                    height: 1,
                    color: Color(0xFFF3F3F3),
                  ),
                ),
                (bloc.userLabels==null || bloc.userLabels.isEmpty)//判断数组是否为空时需要加上是否为null的判断，不然会报错
                ? Container()
                : Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: userLabels(),
                  ),
                )
              ],
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
          (bloc.title == bloc.userDetails)
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

  /*
  * 个性标签
  * */
  List<Widget> userLabels(){
    var tempList=bloc.userLabels.map((value){
      return Container(
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(minWidth: bloc.labelsWidth),
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 153, 0, 1),
            borderRadius: BorderRadius.all(Radius.circular(3.0))
        ),
        child: Text(value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    });
    return tempList.toList();
  }
}