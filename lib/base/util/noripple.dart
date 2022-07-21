import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
//去掉滚动时的上下蓝色波纹动画
class MyBehavior extends ScrollBehavior{
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    if(Platform.isAndroid||Platform.isFuchsia){
      return child;
    }else{
      return super.buildOverscrollIndicator(context, child, details);
    }
  }
}