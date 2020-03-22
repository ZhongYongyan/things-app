import 'dart:convert';

import 'package:app/base/util/Utils.dart';
import 'package:app/view/home/user/component/lib/src/i18n_model.dart';
import 'package:app/view/plugin/PluginBloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:logging/logging.dart';

import 'Message.dart';

class BlueBridge {
  BlueBridge(FlutterWebviewPlugin flutterWebviewPlugin) {
    _flutterWebviewPlugin = flutterWebviewPlugin;
    FlutterBlue.instance.isScanning.listen((isScanning) {
      this.isScanning = isScanning;
    });
  }

  FlutterWebviewPlugin _flutterWebviewPlugin;
  Logger _log = Logger('BlueBridge');
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  String scanResultsLast = '';
  bool isScanning = false;

  void handleMessage(String message) {
    _log.info('message: $message');
    Message msg = Message.fromJson(json.decode(message));
    switch (msg.command) {
      case 'isAvailable':
        _isAvailable(msg);
        break;

      case 'isOn':
        _isOn(msg);
        break;

      case 'isScanning':
        _isScanning(msg);
        break;

      case 'startScan':
        _startScan(msg);
        break;

      case 'stopScan':
        _stopScan(msg);
        break;
    }
  }

  void _postMessage(Message message) {
    _log.info('_postMessage: ${message.toJsonString()}');
    String script = "BlueBridge.handleMessage('${message.toJsonString()}');";
    _flutterWebviewPlugin.evalJavascript(script);
  }

  _isAvailable(Message msg) {
    /// Checks whether the device supports Bluetooth
    _flutterBlue.isAvailable.then((value) {
      _postMessage(msg.success(value));
    });
  }

  _isOn(Message msg) {
    /// Checks whether the device supports Bluetooth
    _flutterBlue.isOn.then((value) {
      _postMessage(msg.success(value));
    });
  }

  _isScanning(Message msg) {
    _flutterBlue.isScanning.map((value) {
      _postMessage(msg.success(value));
    });
  }

  _startScan(Message msg) {
    Future.wait([_flutterBlue.isAvailable, _flutterBlue.isOn]).then((values) {
      var isAvailable = values[0];
      var isOn = values[1];

      if (isAvailable && isOn) {
        if (isScanning) {
          _postMessage(msg.failure('turn_on_bluetooth', '扫描中...'));
        } else {
          _flutterBlue.startScan(timeout: Duration(seconds: 60));
          _flutterBlue.scanResults.listen((scanResults) {
            List<String> names = scanResults.map((x) {
              return x.device.name;
            }).where((name) {
              return name != null && name != '';
            }).toList();

            String scanResultsString = names.join(',');
            if (scanResultsString != scanResultsLast) {
              scanResultsLast = scanResultsString;
              Message message = Message('onScanResult', random());
              message.data = scanResultsString;
              _postMessage(message);
            }
          }, onDone: () {
            _log.info('startScan done');
          }, onError: (error) {
            _log.info('startScan error: $error');
          }, cancelOnError: true);
          _postMessage(msg.success(true));
        }
      } else {
        _postMessage(msg.failure('turn_on_bluetooth', '需要开启蓝牙'));
      }
    });
  }

  _stopScan(Message msg) {
    if (isScanning) {
      scanResultsLast = '';
      _flutterBlue.stopScan();
      _postMessage(msg.success(true));
    } else {
      _postMessage(msg.failure('no_scan', '未启动扫描'));
    }
  }
}
