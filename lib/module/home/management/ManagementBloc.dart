import 'package:app/base/api/DeviceModelAllApis.dart';
import 'package:app/base/entity/DeviceModelAll.dart';
import 'package:app/packages.dart';
import 'package:app/util/Page.dart';
import 'package:app/util/Result.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class ManagementBloc extends BlocBase with LoggingMixin {
  ManagementBloc(BuildContext context, Store store) : super(context, store);
  var loading = 'loadingTag';
  static var loadingTag = DeviceModelAll.fromJson({'sortName': 'loadingTag','model': []});
  var words = <DeviceModelAll>[loadingTag];
  int id = 0;
  var lists = [];
  var indexPage = 1;
  var index = 0;
  bool indexshow = true;
  var text = "按摩椅";

  void back() {
    navigate.pop();
  }

  void startup() {
    //retrieveData();
  }

  void onToDetails(int i) async {
    var model =  lists[i] as DeviceModelAll;
    print(model.id);
    print(model.model);
    setModel(() {
      index = i;
    });
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
      } else {
        var newIndexPage = indexPage + 1;
        setModel(() {
          indexPage = newIndexPage;
        });
      }
//      if (lists.length > 1) {
//        id = words[0].id;
//      }
    });
  }
}
