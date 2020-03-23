import 'dart:async';
import 'dart:convert';

import 'package:app/base/util/Utils.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:logging/logging.dart';

import 'BlueService.dart';
import 'Failure.dart';
import 'Message.dart';

class BlueBridge {
  BlueBridge(FlutterWebviewPlugin flutterWebviewPlugin) {
    _flutterWebviewPlugin = flutterWebviewPlugin;
  }

  FlutterWebviewPlugin _flutterWebviewPlugin;
  Logger _log = Logger('BlueBridge');
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  var _scanResultsHandler;
  BlueService _blueService;

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

      case 'connectDevice':
        _connectDevice(msg);
        break;

      case 'disconnectDevice':
        _disconnectDevice(msg);
        break;

      case 'listenDevice':
        _listenDevice(msg);
        break;

      case 'writeData':
        _writeData(msg);
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

            if (_scanResultsHandler != null) _scanResultsHandler.cancel();
            _scanResultsHandler =
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
              _scanResultsHandler.cancel();
              _log.info('startScan done');
            }, onError: (error) {
              _scanResultsHandler.cancel();
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

  Future<ScanResult> _getDevice(Message msg) {
    Completer<ScanResult> completer = new Completer<ScanResult>();
    String name = msg.data;
    var scanResultsHandler;
    scanResultsHandler = _flutterBlue.scanResults.listen((scanResults) {
      scanResultsHandler.cancel();

      var list = scanResults.where((ele) {
        return ele.device.name == name;
      }).toList();

      if (list.length > 0) {
        var scanResult = list[0];
        completer.complete(scanResult);
      } else {
        completer.completeError(Failure('not_exists', '指定的名称不存在'));
      }
    });
    return completer.future;
  }

  _getDeviceState(Message msg) {
    _getDevice(msg).then((scanResult) {
      var stateListen;
      stateListen = scanResult.device.state.listen((value) {
        stateListen.cancel();
        _postMessage(msg.success(value.toString().split('.').last));
      }, onError: (error) {
        _postMessage(msg.failure('error', '查询状态不成功'));
      });
    }).catchError((error) {
      _postMessage(msg.failure('error', '查询状态不成功'));
    });
  }

  _connectDevice(Message msg) {
    _getDevice(msg).then((scanResult) {
      var stateListen;
      stateListen = scanResult.device.state.listen((value) {
        stateListen.cancel();

        if (value == BluetoothDeviceState.disconnected) {
          scanResult.device
              .connect(autoConnect: true, timeout: Duration(seconds: 30))
              .then((value) {
            _postMessage(msg.success(true));
          }).catchError((error) {
            _postMessage(msg.failure('error', '连接不成功'));
          });
        } else {
          _postMessage(msg.failure('already_connected', '设备已连接'));
        }
      }, onError: (error) {
        _postMessage(msg.failure('error', '查询状态不成功'));
      });
    });
  }

  _disconnectDevice(Message msg) {
    if (_blueService != null) {
      _blueService.stopListen();
      _blueService = null;
    }

    _getDevice(msg).then((scanResult) {
      var stateListen;
      stateListen = scanResult.device.state.listen((value) {
        stateListen.cancel();

        if (value == BluetoothDeviceState.connected) {
          scanResult.device.disconnect().then((value) {
            _postMessage(msg.success(true));
          }).catchError((error) {
            _postMessage(msg.failure('error', '断开连接不成功'));
          });
        } else {
          _postMessage(msg.failure('not_connect', '设备未连接'));
        }
      }, onError: (error) {
        _postMessage(msg.failure('error', '查询状态不成功'));
      });
    });
  }

  _listenDevice(Message msg) {
    _getDevice(msg).then((scanResult) {
      var stateListen;
      stateListen = scanResult.device.state.listen((value) {
        stateListen.cancel();

        if (value == BluetoothDeviceState.connected) {
          _blueService = BlueService(scanResult.device);
          _blueService.startListen((data) {
            Message message = Message('onNotify', random());
            message.data = data.join(',');
            _postMessage(message);
          }).then((value) {
            _postMessage(msg.success(true));
          }).catchError((error) {
            Failure e = error as Failure;
            if (e != null) {
              _postMessage(msg.failure(e.name, e.message));
            } else {
              _postMessage(msg.failure('error', '蓝牙不能识别'));
            }
          });
        } else {
          _postMessage(msg.failure('not_connect', '设备未连接'));
        }
      }, onError: (error) {
        _postMessage(msg.failure('error', '查询状态不成功'));
      });
    });
  }

  _writeData(Message msg) {
    if (_blueService == null) {
      _postMessage(msg.failure('not_connect', '设备未监听'));
    } else {
      String data = msg.data;
      List<int> value = data.split(',').map((value) {
        return int.parse(value);
      }).toList();

      _blueService.writeData(value);
      _postMessage(msg.success(true));
    }
  }
}
