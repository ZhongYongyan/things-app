import 'package:app/base/api/DeviceModelAllApis.dart';
import 'package:app/base/api/SoftwareApis.dart';
import 'package:app/base/entity/DeviceModelAll.dart';
import 'package:app/base/entity/Software.dart';
import 'package:app/base/plugin/PluginManager.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/base/util/Utils.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';

class ManagementBloc extends BlocBase with LoggingMixin {
  ManagementBloc(BuildContext context, Store store) : super(context, store);
  var loading = 'loadingTag';
  static var loadingTag =
      DeviceModelAll.fromJson({'sortName': 'loadingTag', 'model': []});
  var words = <DeviceModelAll>[loadingTag];
  int id = 0;
  var lists = [];
  var indexPage = 1;
  var index = 0;
  bool indexshow = true;
  var text = "按摩椅";
  bool loadShow = false;
  int downloads = 0;

  String get productList => state.lang.localized(Langs.productList);

  void back() {
    if (downloads > 0) {
      Fluttertoast.showToast(
          msg: "插件下载中,请稍后...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    navigate.pop();
  }

  void startup() {
    if (state.management.words.length > 1) {
      setModel(() {
        words = state.management.words;
        id = state.management.id;
        lists = state.management.lists;
        indexPage = state.management.indexPage;
        index = state.management.index;
        indexshow = state.management.indexshow;
        text = state.management.text;
        loadShow = state.management.loadShow;
      });
      onToDetails(state.management.index);
    }
    //retrieveData();
  }

  void onGetUrlDetails(DeviceModel item) async {
    log.info(item.softwareUrl);
    /*setModel(() {
      loadShow = true;
    });
    state.management.loadShow = true;
    Result<Software> response = await SoftwareApis.getSoftware(item.id, 1.0);
    bool code = response.success;
    setModel(() {
      loadShow = false;
    });
    state.management.loadShow = false;*/
    //错误处理
    if (isEmpty(item.softwareUrl)) {
      Fluttertoast.showToast(
          msg: "没有找到插件，请与系统管理员联系",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (downloads > 0) {
      Fluttertoast.showToast(
          msg: "插件下载中,请稍后...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setModel(() {
      item.loadShow = true;
    });
    isDownload(item.softwareUrl).then((url) {
      if (url == null) {
        Fluttertoast.showToast(
            msg: "下载插件中...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 2,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
    computedPluginUrl(item.softwareUrl).then((url) {
      navigate.pushNamed('/plugin', arguments: {"url": url});
      setModel(() {
        item.loadShow = false;
      });
    });
  }

  void toDownload(DeviceModel item) async {
    if (isEmpty(item.softwareUrl)) {
      Fluttertoast.showToast(
          msg: "没有找到插件，请与系统管理员联系",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setModel(() {
      item.isDownloading = true;
      downloads++;
    });
    Fluttertoast.showToast(
        msg: '${item.modelName}插件下载中...',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        textColor: Colors.white,
        fontSize: 16.0);
    computedPluginUrl(item.softwareUrl).then((url) {
      setModel(() {
        item.loadShow = false;
        item.isDownloading = false;
        downloads--;
      });
    });
  }

  void onToDetails(int i) async {
    setModel(() {
      index = i;
    });
    state.management.index = i;
  }

  void retrieveData() async {
    DataResult<DeviceModelAll> response =
        await DeviceModelAllApis.getDeviceModelAll();
    bool code = response.success;
    //错误处理
    lists = response.data;
    Future.delayed(Duration(seconds: 1)).then((e) {
      words.insertAll(words.length - 1, lists.map((student) => student));
      for (DeviceModelAll deviceModelAll in lists) {
        List<DeviceModel> deviceModels = deviceModelAll.model;
        for (DeviceModel deviceModel in deviceModels) {
          isDownload(deviceModel.softwareUrl).then((url) {
            if (url == null) {
              setModel(() {
                deviceModel.loadShow = true;
              });
            }
          });
        }
      }
      if (lists.length < 10) {
        setModel(() {
          indexshow = false;
        });
        state.management.indexshow = false;
      } else {
        var newIndexPage = indexPage + 1;
        setModel(() {
          indexPage = newIndexPage;
        });
        state.management.indexPage = newIndexPage;
      }
      state.management.words = words;
    });
  }

  Future<String> computedPluginUrl(String url) async {
    PluginManager pluginManager = PluginManager();
    return pluginManager.download(url);
//    return 'https://www.baidu.com/';
  }

  Future<String> isDownload(String url) async {
    PluginManager pluginManager = PluginManager();
    return pluginManager.isDownload(url);
  }
}
