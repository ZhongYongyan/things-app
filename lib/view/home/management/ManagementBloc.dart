import 'package:app/base/api/DeviceModelAllApis.dart';
import 'package:app/base/api/SoftwareApis.dart';
import 'package:app/base/entity/DeviceModelAll.dart';
import 'package:app/base/entity/Software.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Result.dart';
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
  void back() {
    navigate.pop();
  }

  void startup() {
    if(state.management.words.length > 1) {
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
    log.info(item.id);
    setModel(() {
      loadShow = true;
    });
    state.management.loadShow = true;
    Result<Software> response = await SoftwareApis.getSoftware(item.id);
    bool code = response.success;
    setModel(() {
      loadShow = false;
    });
    state.management.loadShow = false;
    //错误处理
    if(!code) {
      Fluttertoast.showToast(
          msg: "没有找到插件，请与系统管理员联系",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    navigate.pushNamed('/plugin', arguments: {"url": response.data.url});
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
}
