import 'dart:async';
import 'dart:io';

import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/entity/DeviceVo.dart';
import 'package:app/base/entity/IwaMall.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:app/view/home/user/component/lib/src/i18n_model.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class IwaMallBloc extends BlocBase with LoggingMixin {
  IwaMallBloc(BuildContext context, Store store) : super(context, store);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isOver=false;//表示是否继续翻页
  bool loadShow = true;
  int pageIndex=1;//当前请求页码，初始为1
  double h;
  bool fold =false;//快捷入口默认不展开
  List banners=[],goods=[];
  // List banners=[
  //   {
  //     "pic":"https://axhub.im/ax9/7daa3ef63e5c1293/images/资讯/u162.png"
  //   },
  //   {
  //     "pic":"https://axhub.im/ax9/7daa3ef63e5c1293/images/资讯/u162.png"
  //   }
  // ];
  // List goods=[
  //   {
  //     "mid":'1',
  //     "id":'1',
  //     "name":"颈椎按摩仪K52",
  //     "salenum":"3",
  //     "pointpay":"3",
  //     "label":"轻柔按摩",
  //     "pic":"http://ce.irestapp.com/order/backend/web/pro_images/271/202107240858303001.jpg"
  //   },
  //   {
  //     "mid":'1',
  //     "id":'1',
  //     "name":"颈椎按摩仪K52",
  //     "salenum":"3",
  //     "pointpay":"3",
  //     "label":"轻柔按摩",
  //     "pic":"http://ce.irestapp.com/order/backend/web/pro_images/271/202107240858303001.jpg"
  //   },
  //   {
  //     "mid":'1',
  //     "id":'1',
  //     "name":"颈椎按摩仪K52",
  //     "salenum":"3",
  //     "pointpay":"3",
  //     "label":"轻柔按摩",
  //     "pic":"http://ce.irestapp.com/order/backend/web/pro_images/271/202107240858303001.jpg"
  //   },
  //   {
  //     "mid":'1',
  //     "id":'1',
  //     "name":"颈椎按摩仪K52",
  //     "salenum":"3",
  //     "pointpay":"3",
  //     "label":"轻柔按摩",
  //     "pic":"http://ce.irestapp.com/order/backend/web/pro_images/271/202107240858303001.jpg"
  //   },
  //   {
  //     "mid":'1',
  //     "id":'1',
  //     "name":"颈椎按摩仪K52",
  //     "salenum":"3",
  //     "pointpay":"3",
  //     "label":"轻柔按摩",
  //     "pic":"http://ce.irestapp.com/order/backend/web/pro_images/271/202107240858303001.jpg"
  //   },
  //   {
  //     "mid":'1',
  //     "id":'1',
  //     "name":"颈椎按摩仪K52",
  //     "salenum":"3",
  //     "pointpay":"3",
  //     "label":"轻柔按摩",
  //     "pic":"http://ce.irestapp.com/order/backend/web/pro_images/271/202107240858303001.jpg"
  //   },
  //   {
  //     "mid":'1',
  //     "id":'1',
  //     "name":"颈椎按摩仪K52",
  //     "salenum":"3",
  //     "pointpay":"3",
  //     "label":"12",
  //     "pic":"http://ce.irestapp.com/order/backend/web/pro_images/271/202107240858303001.jpg"
  //   },
  //   {
  //     "mid":'1',
  //     "id":'1',
  //     "name":"颈椎按摩仪K52",
  //     "salenum":"3",
  //     "pointpay":"3",
  //     "label":"轻柔按摩",
  //     "pic":"http://ce.irestapp.com/order/backend/web/pro_images/271/202107240858303001.jpg"
  //   },
  //   {
  //     "mid":1,
  //     "id":'1',
  //     "name":"颈椎按摩仪K52",
  //     "salenum":"3",
  //     "pointpay":"3",
  //     "label":"轻柔按摩",
  //     "pic":"http://ce.irestapp.com/order/backend/web/pro_images/271/202107240858303001.jpg"
  //   },
  //   {
  //     "mid":'1',
  //     "id":'1',
  //     "name":"颈椎按摩仪K52",
  //     "salenum":"3",
  //     "pointpay":"3",
  //     "label":"轻柔按摩",
  //     "pic":"http://ce.irestapp.com/order/backend/web/pro_images/271/202107240858303001.jpg",
  //     "price":'599.00'
  //   },
  // ];
  void startup() async {
    h = MediaQuery.of(context).size.height / 3;
  }

  //获取首页轮播图
  void getHomeData() async {
    IwaResult<IwaMall> response = await IwaMallApis.getHomeData(pageIndex,10);
    print(response);
    bool code = response.success;
    if(pageIndex==1){
      var tempBanner=response.data.banner;
      Future.delayed(Duration(microseconds: 200)).then((e) {
        banners.insertAll(0, tempBanner.map((item) => item));
        print(banners);
        setModel(() {
          banners=banners;
        });
      });
    }
    var goodsTemp = response.data.items;
    bool isOver=response.data.ending;
    Future.delayed(Duration(microseconds: 200)).then((e) {
      goods.insertAll(0, goodsTemp.map((item) => item));
      print(goods);
      setModel((){
        goods=goods;
        loadShow=false;
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  //前往商品详情页
  void goodsDetail(mid){
    navigate.pushNamed('/goodsDetail',arguments: {"mid":mid});
  }

  //展开快捷入口，显示订单和购物车
  void unfold(){
    setModel(() {
      fold=!fold;
    });
    print(fold);
  }

  //前往订单列表页
  void toOrderPage(){
    navigate.pushNamed('/orders',arguments: {"uid":2});
  }

}
