import 'dart:io';
import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
class HomeManagementBloc extends BlocBase with LoggingMixin {
  HomeManagementBloc(BuildContext context, Store store) : super(context, store) {
    homeNameFocus.addListener(() {
      if(!homeNameFocus.hasFocus){
        print(homeNameController.text);
        if(homeNameController.text==''){
          // showToast(msg)
          homeNameController = TextEditingController(text: homeInfo['name']+homeSuffix);
        }else if(homeNameController.text!=(homeInfo['name']+homeSuffix)){
          homeNameController.text=homeNameController.text+homeSuffix;
          showToast(nameEditSuccess);
          editName();
        }
      }
    });
  }
  String get title => state.lang.localized(Langs.homeManage);
  String get homeName => state.lang.localized(Langs.homeName);
  String get createTime => state.lang.localized(Langs.createTime);
  String get homeSuffix => state.lang.localized(Langs.homeSuffix);
  String get familyMembers => state.lang.localized(Langs.familyMembers);
  String get delete => state.lang.localized(Langs.delete);
  String get creator => state.lang.localized(Langs.creator);
  String get cancel => state.lang.localized(Langs.cancel);
  String get determine => state.lang.localized(Langs.determine);
  String get confirmDeleteMember => state.lang.localized(Langs.confirmDeleteMember);
  String get confirmDeleteHome => state.lang.localized(Langs.confirmDeleteHome);
  String get deleteHome => state.lang.localized(Langs.deleteHome);
  String get joinDate => state.lang.localized(Langs.joinDate);
  String get nameEditSuccess => state.lang.localized(Langs.nameEditSuccess);
  String get deleteSuccess => state.lang.localized(Langs.deleteSuccess);
  String get homeDeleteFail => state.lang.localized(Langs.homeDeleteFail);
  bool isEdit = false;//???????????????
  TextEditingController homeNameController;
  FocusNode homeNameFocus = FocusNode();
  List deleteId =[];//???????????????id
  Map homeInfo = {
    "name":'??????????????????????????????????????????',
    "createTime":"2022-07-05",
  };
  List members=[
    {
      "id":1,
      "img":"https://axhub.im/ax9/7daa3ef63e5c1293/images/????????????/u12.png",
      "name":"Simon",
      "createTime":"2020-07-05",
      "creator":true
    },
    {
      "id":2,
      "img":"https://axhub.im/ax9/7daa3ef63e5c1293/images/????????????/u12.png",
      "name":"??????",
      "createTime":"2021-01-05",
      "creator":false
    },
    {
      "id":3,
      "img":"https://axhub.im/ax9/7daa3ef63e5c1293/images/????????????/u12.png",
      "name":"??????",
      "createTime":"2022-02-05",
      "creator":false
    },
    {
      "id":4,
      "img":"https://axhub.im/ax9/7daa3ef63e5c1293/images/????????????/u12.png",
      "name":"Sim?????????????????????????????????????????????????????????on",
      "createTime":"2022-03-25",
      "creator":false
    },
    {
      "id":5,
      "img":"https://axhub.im/ax9/7daa3ef63e5c1293/images/????????????/u12.png",
      "name":"??????",
      "createTime":"2022-07-05",
      "creator":false
    }
  ];

  //?????????
  void start(){
    homeNameController = TextEditingController(text: homeInfo['name']+homeSuffix);//??????????????????
  }

  //?????????????????????????????????
  void editName(){
    setModel(() {
      isEdit=!isEdit;
    });
  }

  //????????????
  void deleteMember(int index){
    if(index>0){//??????index??????0?????????
      deleteId.add(members[index]['id']);
      members.removeAt(index);
      setModel(() {
        members=members;
      });
      showToast(deleteSuccess);
    }
  }

  //????????????
  void deleteHomeHandler(){
    print(132);
  }

  //???????????????
  void back(){
    navigate.pop(deleteId);
  }

  @override
  void dispose() {
    homeNameController.dispose();
    homeNameFocus.dispose();
    super.dispose();
  }
}