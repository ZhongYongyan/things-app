import 'dart:io';
import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/entity/IwaAddress.dart';
import 'package:app/base/entity/IwaGoodsDetail.dart';
import 'package:app/base/entity/IwaMall.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
class ConfirmTheOrderBloc extends BlocBase with LoggingMixin {
  ConfirmTheOrderBloc(BuildContext context, Store store) : super(context, store);
  String get confirmTheOrder => state.lang.localized(Langs.confirmTheOrder);
  String get remark => state.lang.localized(Langs.remark);
  String get remarkPlaceholder => state.lang.localized(Langs.remarkPlaceholder);
  String get total => state.lang.localized(Langs.total);
  String get submitOrder => state.lang.localized(Langs.submitOrder);
  String get payFail => state.lang.localized(Langs.payFail);
  String get addressTip => state.lang.localized(Langs.addressTip);
  String get chooseAddressTip => state.lang.localized(Langs.chooseAddressTip);
  bool submitLoading=false;//是否提交中
  bool loadShow =true;//初次加载
  int iwaId=1;//商城id
  var userAddress= IwaAddress.fromJson({});
  // Map userAddress={
  //   "id":1,
  //   "name":'安徽省sdfsdf',
  //   "phone":'13589563214',
  //   "region":'浙江省 嘉兴市 南湖区',
  //   "street":'清华长三角研究院A幢1203adjfklasdfjakfakldsjf;df',
  //   "isDefault":false
  // };
  List<GoodsDetail> goodsInfo;
  // List goodsInfo=[
  //   {
  //     "id":"3",
  //     "name":"颈椎按摩仪K52",
  //     "label":'5D气动按摩-翡翠绿',
  //     "pointPrice":"13256",
  //     "quantity":3,
  //     "img":'http://ce.irestapp.com/order/backend/web/pro_images/272/202107240909397412.jpg'
  //   }
  // ];
  int totalPrice=0;
  int totalQuantity;
  //将上个页面数据赋值到此页面
  void initPageData(data){
    goodsInfo=data;
    totalQuantity=goodsInfo[0].quantity;
    totalPrice=totalQuantity*goodsInfo[0].pointPrice;
  }

  //获取用户最近使用地址
  void getDetail() async {
    IwaResult<IwaAddress> response = await IwaMallApis.getRecentAddress('13957370521');
    print(response);
    userAddress = response.data;
    Future.delayed(Duration(microseconds: 200)).then((e) {
      setModel(() {
        userAddress = userAddress;
        loadShow=false;
      });
    });
  }

  void getPrePageData(){
    Future.delayed(Duration.zero,(){
      dynamic arguments=ModalRoute.of(context).settings.arguments;
      print(arguments['goods']);
      setModel(() {
        goodsInfo=arguments['goods'];
      });
    });
  }

  // void initAsyncData(type) async {
  //   var data=await MessageService().init(context).getNoticeList(type);
  //   print(data);
  // }

  //处理订单提交
  void submitOrderHandler() async {
    if(userAddress.id==0){
      showToast(chooseAddressTip);
      return;
    }
    if(submitLoading) return;
    setModel(() {
      submitLoading = true;
    });

    FocusScope.of(context).requestFocus(FocusNode());
    // String response = await IwaMallApis.submitOrder(userAddress.id, goodsInfo,state.user.phone, remark);
    String response = await IwaMallApis.submitOrder(userAddress.id, goodsInfo,'13957370521', remark);
    if (response!='err') {
      navigate.pushNamed('/successfulPayment');
    } else {
      showToast(payFail);
    }
    setModel(() {
      submitLoading = false;
    });
  }

  //跳转到地址列表
  void chooseAddress(){
    navigate.pushNamed('/addressList').then(
      (value){
        if(value != null){
          setModel(() {
            userAddress=value;
          });
        }
        print(userAddress);
      }
    );
  }

}