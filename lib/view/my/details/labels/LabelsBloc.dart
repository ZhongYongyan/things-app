import 'package:app/base/api/AffiliateApis.dart';
import 'package:app/base/api/AvatarApis.dart';
import 'package:app/base/api/MemberApis.dart';
import 'package:app/base/entity/Affiliate.dart';
import 'package:app/base/entity/MemberInfo.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'dart:io';
class LabelsBloc extends BlocBase with LoggingMixin{
  LabelsBloc(BuildContext context, Store store) : super(context, store){
    initialize();
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String get title => state.lang.localized(Langs.labels);
  String get preservation => state.lang.localized(Langs.preservation);
  String get nonLabels => state.lang.localized(Langs.nonLabels);
  List allLabels =[
    {
      'title':'类型1',
      'labels':[
        {
          'id':1,
          'name':'啥',
          'status':false
        },
        {
          'id':2,
          'name':'好的',
          'status':false
        },
        {
          'id':3,
          'name':'谢谢',
          'status':false
        },
        {
          'id':4,
          'name':'没关系',
          'status':false
        },
        {
          'id':5,
          'name':'嗯哼',
          'status':false
        },
      ]
    },
    {
      'title':'类型2',
      'labels':[
        {
          'id':6,
          'name':'今天',
          'status':false
        },
        {
          'id':7,
          'name':'明天',
          'status':false
        },
        {
          'id':8,
          'name':'昨天',
          'status':false
        },
        {
          'id':9,
          'name':'后天',
          'status':false
        },
        {
          'id':10,
          'name':'哪天',
          'status':false
        },
      ]
    },
    {
      'title':'类型3',
      'labels':[
        {
          'id':11,
          'name':'鸡毛菜',
          'status':false
        },
        {
          'id':12,
          'name':'番茄',
          'status':false
        },
        {
          'id':13,
          'name':'香菜',
          'status':false
        },
        {
          'id':14,
          'name':'黄瓜',
          'status':false
        },
        {
          'id':15,
          'name':'凤梨',
          'status':false
        },
      ]
    },
  ];
  var labelsWidth;
  List userChoose=[],userChooseLabels=[];//用于存储用户选择的标签,userChoose用于提交后台，userChooseLabels用于渲染上级页面
  Map userChooseMap={};
  bool saveProcessing=false;//用于防止重复提交
  int index=0;
  //获取用户之前已选中的标签
  void initialize(){
    int typeLen=allLabels.length;
    for(int i=0;i<typeLen;i++){
      int labelsLen=allLabels[i]['labels'].length;
      for(int j=0;j<labelsLen;j++){
        if(allLabels[i]['labels'][j]['status']){
          userChoose.add(allLabels[i]['labels'][j]["id"]);
          // index=i+j;
          userChooseMap[i+j]=allLabels[i]['labels'][j]["name"];
        }
      }
    }
  }
  //更新选中状态
  void choose(bool choose,int page,int index){
    setModel(() {
      allLabels[page]['labels'][index]["status"]=choose;
      int key= page==0 ? index : page*100 + index;//因为需要设置唯一索引，此处选择将标签的所在类索引乘以100再加上标签自身索引，作为标签的唯一索引，其作为排序依据，也可以通过依次获取上级类的长度并统计总和再加上当前标签索引，但觉得这样比较麻烦，所以直接默认每个类别不会超过100个
      if(choose){
        userChoose.add(allLabels[page]['labels'][index]["id"]);
        userChooseMap[key]=allLabels[page]['labels'][index]["name"];
      }else{
        userChoose.remove(allLabels[page]['labels'][index]["id"]);
        userChooseMap.remove(key);
      }
    });
  }

  void saveHandler(){
    if(userChoose.length==0){
      Fluttertoast.showToast(
        msg: nonLabels,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        backgroundColor: Colors.black,
      );
      return;
    }
    if(saveProcessing) return;
    setModel(() {
      saveProcessing = true;
    });
    //对map数据进行排序
    List temp=userChooseMap.keys.toList();
    int len=temp.length;
    temp.sort();
    List userChooseLabels=[];
    for(int i=0;i<len;i++){
      userChooseLabels.add(userChooseMap[temp[i]]);
    }
    navigate.pop(userChooseLabels);
  }
}