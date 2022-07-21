import 'dart:async';
import 'dart:io';

import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/entity/DeviceVo.dart';
import 'package:app/base/entity/IwaMall.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
class MallBloc extends BlocBase with LoggingMixin {
  MallBloc(BuildContext context, Store store,this.tabController) : super(context, store){
    tabController.addListener(() {
      if(tabController.index.toDouble() == tabController.animation.value){//当tab切换时加载数据
        onPageChange(tabController.index, p: pageController);
      }
    });
  }
  bool isPageCanChanged = true;
  final TabController tabController;
  PageController pageController=PageController(keepPage: true);
  String get tmMall => state.lang.localized(Langs.tmMall);
  String get pointStore => state.lang.localized(Langs.pointStore);

  List tabs;
  void setup(){
    tabs=[tmMall,pointStore];
  }

  void onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {//判断是哪一个切换
      setModel(() {
        isPageCanChanged = false;
      });
      await pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);//等待pageView切换完毕,再释放pageView监听
      setModel(() {
        isPageCanChanged = true;
      });
    } else {
      tabController.animateTo(index);//切换TabBar
    }
  }
}