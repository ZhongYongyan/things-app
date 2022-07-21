import 'dart:io';
import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
class CreateFamilyBloc extends BlocBase with LoggingMixin {
  CreateFamilyBloc(BuildContext context, Store store):super(context, store);
  String get title => state.lang.localized(Langs.createHome);
  String get submit => state.lang.localized(Langs.submit);
  String get homeName => state.lang.localized(Langs.homeName);
  String get homeNamePlaceholder => state.lang.localized(Langs.homeNamePlaceholder);
  String get createHomeSuccess => state.lang.localized(Langs.createHomeSuccess);

  var name;//家庭名称
  //更新名称
  void setName(value){
    setModel(() {
      name=value;
    });
  }

  //创建家庭
  void createFamily(){
    if(name==''){
      showToast(homeNamePlaceholder);
      return;
    }else{
      showToast(createHomeSuccess);
      Map homeInfo = {
        "id":1,
        "name":name,
        "time":'2022-07-14',
        "creator":true
      };
      Future.delayed(Duration(milliseconds: 1500)).then((value) => navigate.pop(homeInfo));
    }
  }
}