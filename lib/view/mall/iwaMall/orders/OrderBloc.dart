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

class OrderBloc extends BlocBase with LoggingMixin {
  OrderBloc(BuildContext context, Store store, this.tabController) : super(context, store){
    tabController.addListener(() {
      if(tabController.index.toDouble() == tabController.animation.value){//当tab切换时加载数据
        print("ysl${tabController.index}");
        // getOrderList(tabController.index);
      }
    });
    scrollController.addListener(() {
      if(scrollController.position.pixels==scrollController.position.maxScrollExtent){//表示触底
        print('over');
      }

    });
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String get waitDeliver => state.lang.localized(Langs.waitDeliver);
  String get waitReceive => state.lang.localized(Langs.waitReceive);
  String get received => state.lang.localized(Langs.received);
  String get all => state.lang.localized(Langs.all);
  String get confirmReceipt => state.lang.localized(Langs.confirmReceipt);
  String get disbursements => state.lang.localized(Langs.disbursements);
  String get title => state.lang.localized(Langs.myOrder);
  int pageSize=10;
  int pageNum=1;
  int type=0;
  List item;
  bool loadShow=true;
  final TabController tabController;
  ScrollController scrollController =ScrollController();//监听滑动
  PageController pageController = PageController(keepPage: true);
  bool isPageCanChanged=true;
  List orders,order1,order2,order3;
  bool over0,over1,over2,over3;
  // List order = [
  //   {
  //     "id":1,
  //     "sTime":'2022-02-25 16:07:06',
  //     "rTime":'2022-02-26 10:07:06',
  //     "remark":'sdf',
  //     "totalPoints":210,
  //     "orderNum":'GMD20220225160706360',
  //     "aid":30,
  //     "status":'成功',
  //     "details":[
  //       {
  //         "name":"刮痧仪C306-1",
  //         "label":'翡翠',
  //         "num":1,
  //         "img":'http://ce.irestapp.com/order/backend/web/pro_images/268/202107240841078171.jpg',
  //         "pointPrice":50,
  //       },
  //       {
  //         "name":"刮痧仪C306-1",
  //         "label":'5D气息按摩+翡翠',
  //         "num":2,
  //         "img":'http://ce.irestapp.com/order/backend/web/pro_images/268/202107240841078171.jpg',
  //         "pointPrice":80,
  //       },
  //     ]
  //   },
  //   {
  //     "id":1,
  //     "sTime":'2022-02-25 16:07:06',
  //     "rTime":'2022-02-26 10:07:06',
  //     "remark":'sdf',
  //     "totalPoints":210,
  //     "orderNum":'GMD20220225160706360',
  //     "aid":30,
  //     "status":'成功',
  //     "details":[
  //       {
  //         "name":"刮痧仪C306-1",
  //         "label":'翡翠',
  //         "num":1,
  //         "img":'http://ce.irestapp.com/order/backend/web/pro_images/268/202107240841078171.jpg',
  //         "pointPrice":50,
  //       },
  //       {
  //         "name":"刮痧仪C306-1",
  //         "label":'5D气息按摩+翡翠',
  //         "num":2,
  //         "img":'http://ce.irestapp.com/order/backend/web/pro_images/268/202107240841078171.jpg',
  //         "pointPrice":80,
  //       },
  //     ]
  //   },
  //   {
  //     "id":1,
  //     "sTime":'2022-02-25 16:07:06',
  //     "rTime":'2022-02-26 10:07:06',
  //     "remark":'sdf',
  //     "totalPoints":50,
  //     "orderNum":'GMD20220225160706360',
  //     "aid":30,
  //     "status":'成功',
  //     "details":[
  //       {
  //         "name":"刮痧仪C306-1",
  //         "label":'翡翠',
  //         "num":1,
  //         "img":'http://ce.irestapp.com/order/backend/web/pro_images/268/202107240841078171.jpg',
  //         "pointPrice":50,
  //       },
  //     ]
  //   }
  // ];
  void initLabels(){
    item=[all,waitDeliver,waitReceive,received];
  }

  @override
  void dispose(){
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}