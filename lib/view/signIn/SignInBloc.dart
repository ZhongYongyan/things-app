import 'dart:async';
import 'dart:io';
// import 'package:app/base/api/SignApis.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';

class SignInBloc extends BlocBase with LoggingMixin {
  String get title => state.lang.localized(Langs.signIn);
  String get pointDetail => state.lang.localized(Langs.pointDetail);
  String get pointRule => state.lang.localized(Langs.pointRule);
  String get fullStop => state.lang.localized(Langs.fullStop);
  String get semicolon => state.lang.localized(Langs.semicolon);
  String get firstDay => state.lang.localized(Langs.firstDay);
  String get secondDay => state.lang.localized(Langs.secondDay);
  String get thirdDay => state.lang.localized(Langs.thirdDay);
  String get fourthDay => state.lang.localized(Langs.fourthDay);
  String get fifthDay => state.lang.localized(Langs.fifthDay);
  String get sixthDay => state.lang.localized(Langs.sixthDay);
  String get seventhDay => state.lang.localized(Langs.seventhDay);
  SignInBloc(BuildContext context, Store store) : super(context, store);
  List<String> dayOfWeek = ['一','二','三','四','五','六','日'];
  int year =DateTime.now().year;//当前年份
  int month =DateTime.now().month;//当前月份
  int _day =DateTime.now().day;//当前天数
  List dayOfMonth=[];
  List<String> rules=[
    '使用按摩功能可以完成每日签到，签到可以获取积分奖励',
    '每日最多可签到一次',
    '活动以及奖励最终解释权归商家所有'
  ];
  List<String> signDays;
  void startup() async {
    signDays=[firstDay,secondDay,thirdDay,fourthDay,fifthDay,sixthDay,seventhDay];
  }

  //签到事件
  void signIn(int i) async{
    String _today=_day.toString().padLeft(2,'0');
    if(!dayOfMonth[i]['checked'] && dayOfMonth[i]['day']==_today){//仅当未签到时且是当天时触发签到事件
      // Result signResponse = await SignApis.getCurrentMonthSignInRecord(3,dayOfMonth[0]['day']);
      // print(signResponse);
      // setModel(() {
      //   dayOfMonth[i]['checked']=true;
      // });
      // Fluttertoast.showToast(
      //     msg: state.lang.localized(Langs.signInSuccess),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIos: 1,
      //     textColor: Colors.white,
      //     fontSize: 20.0
      // );
    }
  }

  void toPointDetail(){
    navigate.pushNamed('/signDetail');
  }

}
