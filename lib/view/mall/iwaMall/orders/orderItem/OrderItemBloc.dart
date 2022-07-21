import 'dart:io';
import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/entity/IwaAddress.dart';
import 'package:app/base/entity/IwaMall.dart';
import 'package:app/base/entity/IwaOrder.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class OrderItemBloc extends BlocBase with LoggingMixin {
  OrderItemBloc(BuildContext context, Store store): super(context, store);
  String get disbursements => state.lang.localized(Langs.disbursements);
  ScrollController scrollController =ScrollController();//监听滑动
  List orders;
  bool loadShow=true;
  int pageSize=10;
  int pageNum=1;
  //前往详情页
  void toDetail(int index){
    navigate.pushNamed('/orderDetail',arguments: {"info":orders[index]});
  }

  //获取订单列表
  void getOrderList(type) async {
    IwaResult<IwaOrder> response = await IwaMallApis.getOrderList('13957370521', type,  pageSize, pageNum);
    print(response);
    bool code = response.success;
    var orderTemp = response.data.items;
    bool isOver=response.data.over;
    Future.delayed(Duration(microseconds: 200)).then((e) {
      setModel((){
        orders=orderTemp;
        type=type;
        loadShow=false;
      });
    });

  }
}