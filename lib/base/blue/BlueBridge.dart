import 'dart:convert';

import 'package:app/base/util/Utils.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:logging/logging.dart';

import 'Message.dart';

class BlueBridge {
  BlueBridge(FlutterWebviewPlugin flutterWebviewPlugin) {
    _flutterWebviewPlugin = flutterWebviewPlugin;
  }

  FlutterWebviewPlugin _flutterWebviewPlugin;
  Logger _log = Logger('BlueBridge');
  FlutterBlue _flutterBlue = FlutterBlue.instance;

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

      case 'getDeviceState':
        _getDeviceState(msg);
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
        var isScanningListen;
        isScanningListen = FlutterBlue.instance.isScanning.listen((isScanning) {
          isScanningListen.cancel();

          if (isScanning) {
            _postMessage(msg.failure('turn_on_bluetooth', '扫描中...'));
          } else {
            List<ScanResult> scanResultsLast = [];
            _flutterBlue.startScan(timeout: Duration(seconds: 60));
            _flutterBlue.scanResults.listen((scanResults) {
              scanResults = scanResults.where((x) {
                return x.device.name != null && x.device.name != '';
              }).toList();

              String scanResultsString = scanResults.map((x) {
                return x.device.name;
              }).join(',');

              String last = scanResultsLast.map((x) {
                return x.device.name;
              }).join(',');

              if (scanResultsString != last) {
                scanResultsLast = scanResults;
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
        });
      } else {
        _postMessage(msg.failure('turn_on_bluetooth', '需要开启蓝牙'));
      }
    });
  }

  _stopScan(Message msg) {
    var isScanningListen;
    isScanningListen = FlutterBlue.instance.isScanning.listen((isScanning) {
      isScanningListen.cancel();
      if (isScanning) {
        _flutterBlue.stopScan();
        _postMessage(msg.success(true));
      } else {
        _postMessage(msg.failure('no_scan', '未启动扫描'));
      }
    });
  }

  _getDeviceState(Message msg) {
    String name = msg.data;
    var listenHandler;
    listenHandler = _flutterBlue.scanResults.listen((scanResults) {
      listenHandler.cancel();

      var list = scanResults.where((ele) {
        return ele.device.name == name;
      }).toList();

      if (list.length > 0) {
        var scanResult = list[0];
        var stateListen;

        stateListen = scanResult.device.state.listen((value) {
          stateListen.cancel();
          _postMessage(msg.success(value.toString().split('.').last));
        }, onError: (error) {
          _postMessage(msg.failure('error', '查询状态不成功'));
        });
      } else {
        _postMessage(msg.failure('not_exists', '指定的名称不存在'));
      }
    });
  }
}
