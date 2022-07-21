import 'dart:io';
import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
class HealthArchiveBloc extends BlocBase with LoggingMixin {
  HealthArchiveBloc(BuildContext context, Store store)
      : super(context, store) {
    // listController.addListener(() {
    //   if(listController.position.pixels==listController.position.maxScrollExtent){//表示触底
    //
    //   }
    //   print(listController.position);
    // });

  }
  final GlobalKey bottomSheetKey = GlobalKey();
  String get title => state.lang.localized(Langs.healthArchive);
  String get createLabel => state.lang.localized(Langs.createLabel);
  String get homeSuffix => state.lang.localized(Langs.homeSuffix);
  String get exchangeHome => state.lang.localized(Langs.exchangeHome);
  String get manageFamily => state.lang.localized(Langs.manageFamily);
  String get creator => state.lang.localized(Langs.creator);
  String get inviteFamily => state.lang.localized(Langs.inviteFamily);
  double itemHeight = 60;
  int selectedIndex=3;

  List myFamily=[
    {
      "id":1,
      "img":"https://axhub.im/ax9/7daa3ef63e5c1293/images/邀请家人/u12.png",
      "name":"Simon",
      "createTime":"2020-07-05",
      "creator":true
    },
    {
      "id":2,
      "img":"https://axhub.im/ax9/7daa3ef63e5c1293/images/邀请家人/u12.png",
      "name":"张三",
      "createTime":"2021-01-05",
      "creator":false
    },
    {
      "id":3,
      "img":"https://axhub.im/ax9/7daa3ef63e5c1293/images/邀请家人/u12.png",
      "name":"李四",
      "createTime":"2022-02-05",
      "creator":false
    },
    {
      "id":4,
      "img":"https://axhub.im/ax9/7daa3ef63e5c1293/images/邀请家人/u12.png",
      "name":"Sim大法师打发打发斯蒂芬打发斯蒂芬碍事法师on",
      "createTime":"2022-03-25",
      "creator":false
    },
    {
      "id":5,
      "img":"https://axhub.im/ax9/7daa3ef63e5c1293/images/邀请家人/u12.png",
      "name":"万物",
      "createTime":"2022-07-05",
      "creator":false
    }

  ];

  List myHome=[
    {
      "id":1,
      "name":'张三1'
    },
    {
      "id":2,
      "name":'李四6'
    },
    {
      "id":3,
      "name":'阿斯蒂芬'
    },
    {
      "id":4,
      "name":'谢安国'
    },
    {
      "id":5,
      "name":'咔咔咔'
    },
    {
      "id":6,
      "name":'嘎嘎嘎'
    },
    {
      "id":7,
      "name":'莫斯科'
    }
  ];

  Map currentHome = {
    "id":4,
    "name":'谢安国',
    "time":'2022-07-14',
    "creator":true,
    "index":3
  };

  //创建家庭
  void toCreateAFamily(){
    navigate.pushNamed('/createFamily').then((value){
      if(value !=''){
        print(value);
        currentHome=value;
        int index = myHome.length;
        currentHome['img']='https://axhub.im/ax9/7daa3ef63e5c1293/images/邀请家人/u12.png';
        currentHome['index']=index;
        myHome.add(currentHome);
        print(myHome);
        setModel(() {
          currentHome=currentHome;
          myFamily=[value];
          myHome=myHome;
          selectedIndex=index;
        });
      }
    });
  }

  //邀请家人
  void toInvite(){
    print('inviteFamily');
    navigate.pushNamed('/inviteFamily');
  }

  //管理家庭
  void manageHome(){
    print('homeManagement');
    navigate.pushNamed('/homeManagement').then((list){
      print(list);
      if(list != ''){
        for(var item in list){
          myFamily.removeWhere((value)=>value['id']==item);
        }
        print(myFamily);
        setModel(() {
          myFamily=myFamily;
        });
      }
    });
  }

  //选择家庭
  void chooseHome(index){
    setModel(() {
      selectedIndex=index;
    });
  }

  //查看用户健康详情数据
  void viewDetails(int index){
    navigate.pushNamed('/healthData',arguments: {'user':myFamily[index]});
  }
}