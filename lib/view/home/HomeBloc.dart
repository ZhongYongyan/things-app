import 'dart:async';
import 'dart:convert' as convert;

import 'package:app/base/api/AffiliateApis.dart';
import 'package:app/base/api/DeviceVoApis.dart';
import 'package:app/base/api/InfoSortApis.dart';
import 'package:app/base/api/MemberNewsApis.dart';
import 'package:app/base/entity/Device.dart';
import 'package:app/base/entity/DeviceVo.dart';
import 'package:app/base/entity/Info.dart';
import 'package:app/base/entity/MemberNews.dart';
import 'package:app/base/plugin/PluginManager.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Page.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/Auth.dart';
import 'package:app/store/module/GetuiHelper.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getuiflut/getuiflut.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeBloc extends BlocBase with LoggingMixin {
  HomeBloc(BuildContext context, Store store) : super(context, store);
  bool show = false;
  var onReceiveClientId = "";
  Timer _timer;
  bool loadShow = false;
  int isDownloading = 0;
  bool isAndroidNewShow = false;
  bool isDeviceShow = false;
  String get visitor => state.lang.localized(Langs.visitor);
  String get homeExplainAdd => state.lang.localized(Langs.homeExplainAdd);
  String get homeExplainDevices => state.lang.localized(Langs.homeExplainDevices);
  String get homeExplainLife => state.lang.localized(Langs.homeExplainLife);
  String get devicesName => state.lang.localized(Langs.devicesName);
  String get onLine => state.lang.localized(Langs.onLine);
  String get offLine => state.lang.localized(Langs.offLine);
  String get update => state.lang.localized(Langs.update);
  String get downloadNewPlugIns => state.lang.localized(Langs.downloadNewPlugIns);
  String get plugInDownloading => state.lang.localized(Langs.plugInDownloading);
  String get name => state.auth.name != null ? state.auth.name : visitor;
  String get url => state.auth.url != null ? state.auth.url : '';
  var DeviceVoModel = DeviceVo.fromJson({});

  void startup() async {
    var vm = this;
    if (name == "访客") {
      //getUser();
    }

    getDeviceVo();
    getuiHelper.onReceiveClientId((cid){
      if (getuiHelper.id == null) {
        vm.getUserbindAlias(cid);
      }
      Getuiflut().addEventHandler(
        onReceivePayload: (Map<String, dynamic> message) async {},
        onReceiveNotificationResponse: (Map<String, dynamic> message) async {
          //ios点击推送走了这儿
          var actions = message["actions"];
          var actionData = message["actionData"];
          _timer = new Timer(const Duration(milliseconds: 500), () {
            vm.getInfoMemberNews(actions, actionData);
          });
        },
        onAppLinkPayload: (String message) async {},
        onRegisterVoipToken: (String message) async {},
        onReceiveVoipPayLoad: (Map<String, dynamic> message) async {},
        onReceiveMessageData: (Map<String, dynamic> msg) async {
          if (vm.isAndroidNewShow) {
            vm.getPayload(msg);
          }
        },
        onNotificationMessageArrived: (Map<String, dynamic> msg) async {},
        onNotificationMessageClicked: (Map<String, dynamic> msg) async {
          //安卓点击推送走了这儿
          log.info("+++++++++++++++++++++++++++++++++++msg111=$msg");
          vm.isAndroidNewShow = true;
        },
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void to() {
    navigate.pushNamed('/user');
  }

  void add() {
    if (isDownloading > 0) {
      Fluttertoast.showToast(
          msg: state.lang.localized(Langs.plugInDownloadingTips),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    navigate.pushNamed('/management');
  }

  void toPluginUrl(String url) {
    navigate.pushNamed('/plugin', arguments: {"url": url});
  }

  Future<void> toPlugin(int index) async {
    var modelId = DeviceVoModel.devices[index - 2].modelId;
    String deviceSn = DeviceVoModel.devices[index - 2].deviceSn;
    String blueName = DeviceVoModel.devices[index - 2].blueName;
    if (findIsDownloading(modelId)) {
      Fluttertoast.showToast(
          msg: '${findModelName(modelId)}' + state.lang.localized(Langs.plugInDownloadingTips),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    String softwareUrl = findSoftwareUrl(modelId);
    if (softwareUrl == null) {
      Fluttertoast.showToast(
          msg: state.lang.localized(Langs.noPlugInTips),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    await isDownload(softwareUrl).then((url) {
      if (url == null) {
        setModel(() {
          DeviceVoModel.devices[index - 2].loadShow = true;
          for (Device device in DeviceVoModel.devices) {
            if (device.modelId == modelId && device.deviceSn != deviceSn) {
              device.loadShow = false;
            }
          }
        });
        return;
      }else{
        navigate.pushNamed('/plugin', arguments: {"url": url,"deviceSn":deviceSn,"blueName":blueName});
      }
    });
    /*setModel(() {
      loadShow = true;
    });
    Result<Software> response = await SoftwareApis.getSoftware(modelId, 1.0);
    bool code = response.success;
    setModel(() {
      loadShow = false;
    });
    //错误处理
    if (!code) {
      Fluttertoast.showToast(
          msg: "没有找到插件，请与系统管理员联系",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }*/
  }

  Future<void> toDownload(int index) async {
    var modelId = DeviceVoModel.devices[index - 2].modelId;
    String softwareUrl = findSoftwareUrl(modelId);
    if (findIsDownloading(modelId)) {
      Fluttertoast.showToast(
          msg: '${findModelName(modelId)}' + state.lang.localized(Langs.plugInDownloadingTips),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      DeviceVoModel.devices[index - 2].loadShow = false;
      return;
    }
    if (softwareUrl == null) {
      Fluttertoast.showToast(
          msg: state.lang.localized(Langs.noPlugInTips),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setModel(() {
      var item = this
          .DeviceVoModel
          .deviceModels
          .firstWhere((item) => item.id == modelId);
      item.isDownloading = true;
      isDownloading++;
    });
    await download(softwareUrl).then((url) {
      setModel(() {
        DeviceVoModel.devices[index - 2].loadShow = false;
        var item = this
            .DeviceVoModel
            .deviceModels
            .firstWhere((item) => item.id == modelId);
        item.isDownloading = false;
        isDownloading--;
      });
    });
  }

  void getPayload(Map<String, dynamic> payload) async {
    print("推送消息请求2222来了111$payload}");
    var payloads = payload["payload"];
    Map<String, dynamic> item = convert.jsonDecode(payloads);
    var actionData = item["actionData"];
    var actions = item["actions"];
    getInfoMemberNews(actions, actionData);
  }

  //获取推送消息详情
  void getInfoMemberNews(String actions, var actionData) async {
    print("推送消息请求来了111");
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

  //获取消息详情 跳转详情页
  void getDelInfoSort(int id) async {
    Result<MemberNews> response = await MemberNewsApis.getInfoMemberNews(id);
    bool code = response.success;
    if (code) {
      navigate.pushNamed('/msgDetails', arguments: {"model": response.data});
    } else {
      print("消息详情请求失败了");
    }
  }

  //获取资讯详情 跳转详情页
  void getInformation(int id) async {
    Result<Info> response = await InfoSortApis.getDelInfoSort(id);
    bool code = response.success;
    if (code) {
      navigate.pushNamed('/details', arguments: {"model": response.data});
    } else {
      print("消息详情请求失败了");
    }
  }

  void getUser() async {
    Result<Page> response = await AffiliateApis.getAffiliate(1, 10, "ASC");
    bool code = response.success;
    var list = response.data.items;
    if (list.length > 0) {
      dispatch(authActions.user(list[0].nickname));
      dispatch(authActions.url(list[0].avatar));
    }
  }

  void getUserbindAlias(String cid) async {
//    Result<Page> response = await AffiliateApis.getAffiliate(1, 10, "ASC");
//    bool code = response.success;
//    var list = response.data.items;
//    if (list.length > 0) {
      print("创建别名 用于别名推送");
      //创建别名 用于别名推送
      var id = state.auth.id;
      log.info("+++++++++++++++++++++++++++++++++++创建别名id=$id");
      log.info("+++++++++++++++++++++++++++++++++++创建别名cid=$cid");
      if (id != "" && cid != "") {
        log.info("+++++++++++++++++++++++++++++++++++创建别名成功了");
//        Getuiflut().bindAlias(id, cid);
        Getuiflut().bindAlias(id.toString(), cid);
        List<String> ids = List();
        ids.add(id.toString());
        Getuiflut().setTag(ids);
        getuiHelper.id = id.toString();
      }
//    }
  }

  void getDeviceVo() async {
    Result<DeviceVo> response = await DeviceVoApis.getDeviceVo(state.app.companyId);
    bool code = response.success;
    if (code) {
      var data = response.data;
      setModel(() {
        DeviceVoModel = data;
        isDeviceShow = true;
      });
    } else {}
  }

  String findSortName(int sortId) {
    var item =
    this.DeviceVoModel.deviceSorts.firstWhere((item) => item.id == sortId);
    return item.sortName;
  }

  String findModelName(int modelId) {
    var item = this
        .DeviceVoModel
        .deviceModels
        .firstWhere((item) => item.id == modelId);
    return item.modelName;
  }

  bool findIsDownloading(int modelId) {
    var item = this
        .DeviceVoModel
        .deviceModels
        .firstWhere((item) => item.id == modelId);
    return item.isDownloading;
  }

  String findSoftwareUrl(int modelId) {
    var item = this
        .DeviceVoModel
        .deviceModels
        .firstWhere((item) => item.id == modelId);
    return item.softwareUrl;
  }

  bool findLoadShow(int modelId) {
    var item = this
        .DeviceVoModel
        .deviceModels
        .firstWhere((item) => item.id == modelId);
    return item.loadShow;
  }

  String findModelIcon(int modelId) {
    var item = this
        .DeviceVoModel
        .deviceModels
        .firstWhere((item) => item.id == modelId);
    return item.modelIcon;
  }

  Future<String> isDownload(String url) async {
    PluginManager pluginManager = PluginManager();
    return pluginManager.isDownload(url);
  }

  Future<String> download(String url) async {
    PluginManager pluginManager = PluginManager();
    return pluginManager.download(url);
  }
}
