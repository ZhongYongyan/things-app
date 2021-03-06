import 'dart:async';
import 'dart:convert' as convert;

import 'package:app/base/api/InfoSortApis.dart';
import 'package:app/base/api/MemberNewsApis.dart';
import 'package:app/base/entity/Info.dart';
import 'package:app/base/entity/MemberNews.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Paged.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/Msg.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getuiflut/getuiflut.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class MsgBloc extends BlocBase with LoggingMixin {
  MsgBloc(BuildContext context, Store store) : super(context, store);
  var loading = 'loadingTag';
  static var loadingTag = MemberNews.fromJson({'title': 'loadingTag'});
  var words = <MemberNews>[loadingTag];
  var textList = [];
  int sortId = 0;
  var lists = [];
  var indexPage = 1;
  bool indexshow = true;
  int createNumber = 0;
  String get message => state.lang.localized(Langs.message);
  String get messageTips => state.lang.localized(Langs.messageTips);
  Timer _timer;
  bool isAndroidNewShow = true;
  Future startup() async {
    var vm = this;
    if (state.msg.words.length != 1) {
      setModel(() {
        words = state.msg.words;
        indexPage = state.msg.indexPage;
        indexshow = state.msg.indexshow;
      });
    }
//    getByCreateNewsNumber();
    Getuiflut().addEventHandler(
      onNotificationMessageArrived: (Map<String, dynamic> msg) async {
        Getuiflut().resetBadge();
        String taskId = msg["taskId"];
          print('-------------------------------------$taskId');
          Result<MemberNews> response = await MemberNewsApis.getInfoMemberNewsByTaskId(taskId);
          bool code = response.success;
          if(code) {
            int number = await MemberNewsApis.getByCreateNewsNumber();
            setModel((){
              state.app.createNumber = number;
            });
            MemberNews memberNews =  response.data;
            if (memberNews.actions == "OPEN_NEWS") {
              updateData();
            }
          }
      },
      onReceiveNotificationResponse: (Map<String, dynamic> message) async {
        //ios????????????????????????
        var actions = message["actions"];
        var actionData = message["actionData"];
        _timer = new Timer(const Duration(milliseconds: 500), () {
          vm.getInfoMemberNews(actions, actionData);
        });
      },
      onReceivePayload: (Map<String, dynamic> message) async {},
      onAppLinkPayload: (String message) async {},
      onRegisterVoipToken: (String message) async {},
      onReceiveVoipPayLoad: (Map<String, dynamic> message) async {},
      onReceiveMessageData: (Map<String, dynamic> msg) async {
        if (vm.isAndroidNewShow) {
          vm.getPayload(msg);
        }
      },
      onNotificationMessageClicked: (Map<String, dynamic> msg) async {
        //??????????????????????????????
        log.info("+++++++++++++++++++++++++++++++++++msg111=$msg");
        vm.isAndroidNewShow = true;
      },
    );

  }

  Future<void> onToDetails(int i) async {
    MemberNews memberNews = words[i];
    String status = memberNews.newsStatus;
    if ("CREATE" == status) {
      updateMemberStatus(memberNews.id);
      words[i].newsStatus = "READ";
    }
    Result<MemberNews> response = await MemberNewsApis.getInfoMemberNews(words[i].newsId);
    bool code = response.success;
    if (code) {
      navigate.pushNamed('/msgDetails', arguments: {"model": response.data});
    } else {
      onRefresh();
      Fluttertoast.showToast(
          msg: state.lang.localized(Langs.messageDelete),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
    }

  }

  void retrieveData() async {
    lists = [];
    Result<Paged> response =
        await MemberNewsApis.getMemberNews(indexPage, 10, "DESC");
    bool code = response.success;
    if (!code) {
      setModel(() {
        indexshow = false;
      });
      state.msg.indexshow = false;
      return;
    }
    //????????????
    lists = response.data.items;
    Future.delayed(Duration(seconds: 1)).then((e) {
      words.insertAll(words.length - 1, lists.map((student) => student));
      if (lists.length < 10) {
        setModel(() {
          indexshow = false;
        });
        state.msg.indexshow = false;
      } else {
        var newIndexPage = indexPage + 1;
        setModel(() {
          indexPage = newIndexPage;
        });
        state.msg.indexPage = newIndexPage;
      }
      state.msg.words = words;
    });
  }

  void updateData() async {
    indexPage = 1;
    words = <MemberNews>[loadingTag];
    retrieveData();
  }

  void getPayload(Map<String, dynamic> payload) async {
    print("??????????????????2222??????111$payload}");
    var payloads = payload["payload"];
    Map<String, dynamic> item = convert.jsonDecode(payloads);
    var actionData = item["actionData"];
    var actions = item["actions"];
    getInfoMemberNews(actions, actionData);
  }

  //????????????????????????
  void getInfoMemberNews(String actions, var actionData) async {
    print("????????????????????????111");
    switch (actions) {
      case 'OPEN_URL':
        if (await canLaunch(actionData)) {
          await launch(actionData);
        } else {
          throw 'Could not launch $actionData';
        }
        break;
      case 'OPEN_INFO':
        getInformation(int.parse(actionData));
        break;
      case 'OPEN_NEWS':
        getDelInfoSort(int.parse(actionData));
        break;
    }
  }

  //?????????????????? ???????????????
  void getDelInfoSort(int id) async {
    Result<MemberNews> response = await MemberNewsApis.getInfoMemberNews(id);
    bool code = response.success;
    if (code) {
      onRefresh();
      navigate.pushNamed('/msgDetails', arguments: {"model": response.data});
    } else {
      navigate.pushNamed('/msg');
    }
  }

  //?????????????????? ???????????????
  void getInformation(int id) async {
    Result<Info> response = await InfoSortApis.getDelInfoSort(id);
    bool code = response.success;
    if (code) {
      navigate.pushNamed('/details', arguments: {"model": response.data});
    } else {
      print("???????????????????????????");
    }
  }

  Future<void> onRefresh() async {
    print("??????????????????");
    indexshow = true;
    indexPage = 1;
    words = <MemberNews>[loadingTag];
    lists = [];
    Result<Paged> response =
    await MemberNewsApis.getMemberNews(indexPage, 10, "DESC");
    bool code = response.success;
    //????????????
    if (!code) {
      log.info("??????????????????", response.message);
      setModel(() {
        indexshow = false;
      });
      state.msg.indexshow = false;
      await Future.delayed(Duration(seconds: 1)).then((e){

      });
      return;
    }
    lists = response.data.items;
    await Future.delayed(Duration(seconds: 1)).then((e){
      words.insertAll(words.length - 1, lists.map((student) => student));
      if (lists.length < 10) {
        setModel(() {
          indexshow = false;
        });
        state.msg.indexshow = false;
      } else {
        var newIndexPage = indexPage + 1;
        setModel(() {
          indexPage = newIndexPage;
        });
        state.msg.indexPage = newIndexPage;
      }
      state.msg.words = words;
    });

  }

  //????????????????????????
  void updateMemberStatus(int id) async {
    await MemberNewsApis.updateMemberNewStatus(id);
  }
}
