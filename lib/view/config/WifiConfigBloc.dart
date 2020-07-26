import 'package:app/base/UI.dart';
import 'package:app/base/blue/BleNetworkPlugin.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';

class WifiConfigBloc extends BlocBase with LoggingMixin {
  WifiConfigBloc(BuildContext context, Store<StoreState> store) : super(context, store);
  var scanResultChannel = BasicMessageChannel("scanResult", StandardMessageCodec());
  var stopScanChannel = BasicMessageChannel("stopScan", StandardMessageCodec());

  var entries = Set<String>();
  var selectedItem = '';

  final TextEditingController usernameController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');

  EasyRefreshController refreshController = EasyRefreshController();

  void startup() {
    scanResultChannel.setMessageHandler((message) async {
      print("scanResult:receive--+$message");
      List<dynamic> items = message;
      setModel(() {
        items.forEach((f) {
          entries.add(f);
        });
      });
    });

    stopScanChannel.setMessageHandler((message) async {
      refreshController.finishRefresh();
      print("stopScan:receive--+$message");
    });

    // startScan();
  }

  void startScan() {
    BleNetworkPlugin.startScan();
  }

  void stopScan() {
    refreshController.finishRefresh();
    BleNetworkPlugin.stopScan();
  }

  select(String name) {
    setModel(() {
      selectedItem = name;
    });
  }

  void toBack() {
    navigate.pop();
  }

  void submit() {
    var ssid = usernameController.text;
    var password = passwordController.text;

    if (ssid.isEmpty) {
      UI.toast('请输入网络名称');
      return;
    }

    if (password.isEmpty) {
      UI.toast('请输入网络密码');
      return;
    }

    if (selectedItem.isEmpty) {
      UI.toast('请选译蓝牙设备');
      return;
    }

    BleNetworkPlugin.setup(ssid, password, selectedItem).then((value) {
      UI.toast('网络配置成功');
    }).catchError((error) {
      UI.toast('网络配置失败');
    });
  }
}
