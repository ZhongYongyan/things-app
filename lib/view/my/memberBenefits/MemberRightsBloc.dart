import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:redux/redux.dart';
class MemberRightsBloc extends BlocBase with LoggingMixin {
  MemberRightsBloc(BuildContext context, Store store) : super(context, store);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String get title => state.lang.localized(Langs.memberRights);
  String get rewardsForLevelUp => state.lang.localized(Langs.rewardsForLevelUp);
  String get member => state.lang.localized(Langs.member);//会员
  String get rights => state.lang.localized(Langs.rights);//权益
  String get preLevelTip => state.lang.localized(Langs.preLevelTip);
  String get nextLevelTip => state.lang.localized(Langs.nextLevelTip);//会员
  String get growthValue => state.lang.localized(Langs.growthValue);//权益
  String myPoint='100';
  String differenceToNextLevel='1';//距离下个等级的积分
  List levels=[
    {
      "level":'1',
      "name":"白银",
      "backgroundImg":"https://axhub.im/ax9/7daa3ef63e5c1293/images/资讯/u162.png",
      "condition":'1000',
      "rights":[
        {
          "img":"",
          "label":"权益1",
        }
      ],
    },
    {
      "level":'2',
      "name":"黄金",
      "backgroundImg":"https://axhub.im/ax9/7daa3ef63e5c1293/images/资讯/u162.png",
      "condition":'2000',
      "rights":[
        {
          "img":"",
          "label":"权益1",
        },
        {
          "img":"",
          "label":"权益2",
        }
      ],
    },
    {
      "level":'3',
      "name":"铂金",
      "backgroundImg":"https://axhub.im/ax9/7daa3ef63e5c1293/images/资讯/u162.png",
      "condition":'5000',
      "rights":[
        {
          "img":"",
          "label":"权益1",
        },
        {
          "img":"",
          "label":"权益2",
        },
        {
          "img":"",
          "label":"权益3",
        },
      ],
    },
    {
      "level":'4',
      "name":"钻石",
      "backgroundImg":"https://axhub.im/ax9/7daa3ef63e5c1293/images/资讯/u162.png",
      "condition":'10000',
      "rights":[
        {
          "img":"",
          "label":"权益1",
        },
        {
          "img":"",
          "label":"权益2",
        },
        {
          "img":"",
          "label":"权益3",
        },
        {
          "img":"",
          "label":"权益4",
        },
      ],
    }
  ];//会员权益
  final userLevel=1;//用户当前等级
  int currentLevel=1;//当前会员等级
  List rewards=[
    {
      "reward":"500",
      "type":"积分",
      "status":0
    }
  ];//历史升级奖励

  //监听等级滑动，实时切换不同等级的权益
  void indexChanged(int index){
    setModel(() {
      currentLevel=index;
    });
  }

  //领取升级礼包
  void receive(int index){
    rewards[index]['status']=1;
    setModel(() {
      rewards=rewards;
    });
  }
}