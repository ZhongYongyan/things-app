import 'dart:io';
import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/entity/IwaAddress.dart';
import 'package:app/base/entity/IwaMall.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
class OrderDetailBloc extends BlocBase with LoggingMixin {
  OrderDetailBloc(BuildContext context, Store store) : super(context, store);
  String get accountPayable => state.lang.localized(Langs.accountPayable);
  String get buyTime => state.lang.localized(Langs.buyTime);
  String get receiveTime => state.lang.localized(Langs.receiveTime);
  String get orderNum => state.lang.localized(Langs.orderNum);
  String get remark => state.lang.localized(Langs.remark);
  String get disbursements => state.lang.localized(Langs.disbursements);
  String title;
  List orderInfoDetail,orderInfoLabel;
  bool loadShow=true;
  var userAddress;
  // Map userAddress={
  //   "id":1,
  //   "name":'安徽省sdfsdf',
  //   "phone":'13589563214',
  //   "region":'浙江省 嘉兴市 南湖区',
  //   "street":'清华长三角研究院A幢1203adjfklasdfjakfakldsjf;df',
  //   "isDefault":false
  // };

  // List goodsInfo=[
  //   {
  //     "id":"3",
  //     "name":"颈椎按摩仪K52",
  //     "label":'5D气动按摩-翡翠绿',
  //     "pointPrice":"13256",
  //     "quantity":3,
  //     "img":'http://ce.irestapp.com/order/backend/web/pro_images/272/202107240909397412.jpg'
  //   },
  //   {
  //     "id":"3",
  //     "name":"颈椎按摩仪K52",
  //     "label":'5D气动按摩-翡翠绿',
  //     "pointPrice":"13256",
  //     "quantity":3,
  //     "img":'http://ce.irestapp.com/order/backend/web/pro_images/272/202107240909397412.jpg'
  //   }
  // ];
  var goodsInfo;
  // Map goodsInfo = {
  //   "id":1,
  //   "sTime":'2022-02-25 16:07:06',
  //   "rTime":null,
  //   "remark":'1按实际打客服就ask两地分居阿来得及发卡打飞机啊斯蒂芬库里撒打飞机俺看电视1按实际打客服就ask两地分居阿来得及发卡打飞机啊斯蒂芬库里撒打飞机俺看电视',
  //   "totalPoints":210,
  //   "orderNum":'GMD20220225160706360',
  //   "aid":30,
  //   "status":'成功',
  //   "success":0,
  //   "details":[
  //     {
  //       "name":"刮痧仪C306-1",
  //       "label":'翡翠',
  //       "num":1,
  //       "img":'http://ce.irestapp.com/order/backend/web/pro_images/268/202107240841078171.jpg',
  //       "pointPrice":50,
  //     },
  //     {
  //       "name":"刮痧仪C306-1按实际打客服就ask两地分居阿来得及发卡打飞机啊斯蒂芬库里撒打飞机俺看电视",
  //       "label":'5D气息按摩+翡翠',
  //       "num":2,
  //       "img":'http://ce.irestapp.com/order/backend/web/pro_images/268/202107240841078171.jpg',
  //       "pointPrice":80,
  //     },
  //     {
  //       "name":"刮痧仪C306-1",
  //       "label":'翡翠',
  //       "num":1,
  //       "img":'http://ce.irestapp.com/order/backend/web/pro_images/268/202107240841078171.jpg',
  //       "pointPrice":50,
  //     },
  //     {
  //       "name":"刮痧仪C306-1按实际打客服就ask两地分居阿来得及发卡打飞机啊斯蒂芬库里撒打飞机俺看电视",
  //       "label":'5D气息按摩+翡翠',
  //       "num":2,
  //       "img":'http://ce.irestapp.com/order/backend/web/pro_images/268/202107240841078171.jpg',
  //       "pointPrice":80,
  //     },
  //     {
  //       "name":"刮痧仪C306-1",
  //       "label":'翡翠',
  //       "num":1,
  //       "img":'http://ce.irestapp.com/order/backend/web/pro_images/268/202107240841078171.jpg',
  //       "pointPrice":50,
  //     },
  //     {
  //       "name":"刮痧仪C306-1按实际打客服就ask两地分居阿来得及发卡打飞机啊斯蒂芬库里撒打飞机俺看电视",
  //       "label":'5D气息按摩+翡翠',
  //       "num":2,
  //       "img":'http://ce.irestapp.com/order/backend/web/pro_images/268/202107240841078171.jpg',
  //       "pointPrice":80,
  //     },
  //     {
  //       "name":"刮痧仪C306-1",
  //       "label":'翡翠',
  //       "num":1,
  //       "img":'http://ce.irestapp.com/order/backend/web/pro_images/268/202107240841078171.jpg',
  //       "pointPrice":50,
  //     },
  //     {
  //       "name":"刮痧仪C306-1按实际打客服就ask两地分居阿来得及发卡打飞机啊斯蒂芬库里撒打飞机俺看电视",
  //       "label":'5D气息按摩+翡翠',
  //       "num":2,
  //       "img":'http://ce.irestapp.com/order/backend/web/pro_images/268/202107240841078171.jpg',
  //       "pointPrice":80,
  //     },
  //   ]
  // };

  //初始化页面数据
  void initLabels(){
    //订单详情数据
    orderInfoLabel=[orderNum,buyTime];
    orderInfoDetail=[goodsInfo.orderNum,goodsInfo.sTime];
    if(goodsInfo.cTime != null && goodsInfo.cTime.isNotEmpty){
      orderInfoLabel.add(receiveTime);
      orderInfoDetail.add(goodsInfo.cTime);
    }
    if(goodsInfo.remark != null && goodsInfo.remark.isNotEmpty){
      orderInfoLabel.add(remark);
      orderInfoDetail.add(goodsInfo.remark);
    }
    getOrderDetail();
  }

  //获取订单详情
  void getOrderDetail() async {
    IwaResult<IwaAddress> response = await IwaMallApis.getOrderDetail(goodsInfo.id);
    bool code = response.success;
    var detail = response.data;
    Future.delayed(Duration(microseconds: 200)).then((e) {
      setModel((){
        userAddress=detail;
        loadShow=false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}