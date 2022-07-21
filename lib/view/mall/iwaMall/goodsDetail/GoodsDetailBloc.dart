import 'dart:io';
import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/entity/IwaGoodsDetail.dart';
import 'package:app/base/entity/IwaMall.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
class GoodsDetailBloc extends BlocBase with LoggingMixin {
  GoodsDetailBloc(BuildContext context, Store store) : super(context, store);
  String get saleNum => state.lang.localized(Langs.saleNum);
  String get goodsDetailLabel => state.lang.localized(Langs.goodsDetailLabel);
  String get colorLabel => state.lang.localized(Langs.colorLabel);
  String get qtyLabel => state.lang.localized(Langs.qtyLabel);
  String get minQuantityTip => state.lang.localized(Langs.minQuantityTip);
  String get maxQuantityTip => state.lang.localized(Langs.maxQuantityTip);
  String get determine => state.lang.localized(Langs.determine);
  String get buyNow => state.lang.localized(Langs.buyNow);
  String get addToCart => state.lang.localized(Langs.addToCart);
  String get customerService => state.lang.localized(Langs.customerService);
  String get cart => state.lang.localized(Langs.cart);
  bool loadShow=true;
  int mid;
  // List banners=[
  //   {
  //     "imageurl":"https://axhub.im/ax9/7daa3ef63e5c1293/images/资讯/u162.png"
  //   },
  //   {
  //     "imageurl":"https://axhub.im/ax9/7daa3ef63e5c1293/images/资讯/u162.png"
  //   }
  // ];//轮播图
  // List detailPics=[
  //   {
  //     "imageurl":"https://axhub.im/ax9/7daa3ef63e5c1293/images/资讯/u162.png"
  //   },
  //   {
  //     "imageurl":"https://ce.irestapp.com/order/backend/web/pro_images/200/202008181109438782.jpg"
  //   },
  //   {
  //     "imageurl":"https://axhub.im/ax9/7daa3ef63e5c1293/images/资讯/u162.png"
  //   },
  //   {
  //     "imageurl":"https://ce.irestapp.com/order/backend/web/pro_images/200/202008181109438782.jpg"
  //   }
  // ];//商品详情图
  // List goodsDetail=[
  //   {
  //     "id":"272",
  //     "name":"颈椎按摩仪K52",
  //     "color":"翡翠绿",
  //     "pointPrice":6390,
  //     "salenum":'123',
  //     "img":"http://ce.irestapp.com/order/backend/web/pro_images/272/202107240909397412.jpg",
  //     "quantity":0
  //   },
  //   {
  //     "id":"272",
  //     "name":"颈椎按摩仪K52",
  //     "color":"阳光橙",
  //     "pointPrice":6390,
  //     "salenum":'456',
  //     "img":"http://ce.irestapp.com/order/backend/web/pro_images/272/202107240909397412.jpg",
  //     "quantity":0
  //   },
  //   {
  //     "id":"272",
  //     "name":"颈椎按摩仪K52",
  //     "color":"阳光橙",
  //     "pointPrice":6390,
  //     "salenum":'456',
  //     "img":"http://ce.irestapp.com/order/backend/web/pro_images/272/202107240909397412.jpg",
  //     "quantity":0
  //   },
  //   {
  //     "id":"272",
  //     "name":"颈椎按摩仪K52",
  //     "color":"阳光橙",
  //     "pointPrice":6390,
  //     "salenum":'456',
  //     "img":"http://ce.irestapp.com/order/backend/web/pro_images/272/202107240909397412.jpg",
  //     "quantity":0
  //   },
  //   {
  //     "id":"272",
  //     "name":"颈椎按摩仪K52",
  //     "color":"阳光橙",
  //     "pointPrice":6390,
  //     "salenum":'456',
  //     "img":"http://ce.irestapp.com/order/backend/web/pro_images/272/202107240909397412.jpg",
  //     "quantity":0
  //   },
  //   {
  //     "id":"272",
  //     "name":"颈椎按摩仪K52",
  //     "color":"阳光橙",
  //     "pointPrice":6390,
  //     "salenum":'456',
  //     "img":"http://ce.irestapp.com/order/backend/web/pro_images/272/202107240909397412.jpg",
  //     "quantity":0
  //   },
  //   {
  //     "id":"272",
  //     "name":"颈椎按摩仪K52",
  //     "color":"阳光橙",
  //     "pointPrice":6390,
  //     "salenum":'456',
  //     "img":"http://ce.irestapp.com/order/backend/web/pro_images/272/202107240909397412.jpg",
  //     "quantity":0
  //   },
  // ];//商品详情
  List<GoodsDetail> goodsDetail;
  List<String> banners;
  List<String> detailPics;
  int saleNumber=0;
  int productIndex=0;//产品样式索引
  int quantity=1;//商品数量
  bool isBoundary=false;//数量是否到达边界，即1和999
  void overRange(message) {
    print(isBoundary);
    if(isBoundary) return;
    isBoundary=true;
    showToast(message).then((value) => isBoundary=false);
  }

  //获取商品详情
  void getDetail() async {
    IwaResult<IwaGoodsDetail> response = await IwaMallApis.getDetail(mid);
    print(response);
    goodsDetail = response.data.goodsDetail;
    banners = response.data.banners;
    detailPics=response.data.detailPics;
    saleNumber=response.data.saleNum;
    Future.delayed(Duration(microseconds: 200)).then((e) {
      setModel(() {
        goodsDetail = goodsDetail;
        banners = banners;
        detailPics=detailPics;
        saleNumber=saleNumber;
        loadShow=false;
      });
    });
  }

  //确认用户选择
  void confirmChoose(String kind){
    if(kind=='cart'){//加入购物车

    }else{//立即购买
      goodsDetail[productIndex].quantity=quantity;
      navigate.pushReplacementNamed('/confirmTheOrder',arguments: {"goods":[goodsDetail[productIndex]]});
    }
  }

}