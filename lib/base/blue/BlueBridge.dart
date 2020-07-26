import 'dart:async';
import 'dart:convert';

import 'package:app/base/util/Utils.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:logging/logging.dart';

import 'BlueService.dart';
import 'Failure.dart';
import 'Message.dart';
import 'Utils.dart';
import 'BlueProtocol.dart';

class BlueBridge {
  BlueBridge(FlutterWebviewPlugin flutterWebviewPlugin) {
    _flutterWebviewPlugin = flutterWebviewPlugin;
  }

  FlutterWebviewPlugin _flutterWebviewPlugin;
  Logger _log = Logger('BlueBridge');
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  var _scanResultsHandler;
  BlueService _blueService;
  Message _getMsg;
  BlueProtocol _blueProtocol = BlueProtocol();
  String _deviceName;

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

      case 'startListen':
        _startListen(msg);
        break;

      case 'stopListen':
        _stopListen(msg);
        break;

      case 'writeData':
        _writeData(msg);
        break;

      case 'setupWiFi':
        _setupWiFi(msg);
        break;

      default:
        _getBlueProtocol(msg);
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
    disconnect();
    Future.wait([_flutterBlue.isAvailable, _flutterBlue.isOn]).then((values) {
      var isAvailable = values[0];
      var isOn = values[1];

      if (isAvailable && isOn) {
        var isScanningListen;
        isScanningListen = FlutterBlue.instance.isScanning.listen((isScanning) {
          isScanningListen.cancel();
          if (!isScanning) {
            _flutterBlue.startScan(timeout: Duration(seconds: 60));
          }
          List<ScanResult> scanResultsLast = [];
          if (_scanResultsHandler != null) _scanResultsHandler.cancel();
          _scanResultsHandler =
              _flutterBlue.scanResults.listen((scanResults) {

                _log.info('scanResults: $scanResults');

            scanResults = scanResults.where((x) {
              return x.device.name != null && x.device.name != '' && x.device.name.startsWith("A1");
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
//          }
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

  Future<BluetoothDevice> _getDevice(Message msg) {
    Completer<BluetoothDevice> completer = new Completer<BluetoothDevice>();
    String name = msg.data;
    _deviceName = name;
    var scanResultsHandler;
    scanResultsHandler = _flutterBlue.scanResults.listen((scanResults) {
      scanResultsHandler.cancel();

      var list = scanResults.where((ele) {
        return ele.device.name == name;
      }).toList();

      if (list.length > 0) {
        var scanResult = list[0];
        completer.complete(scanResult.device);
      } else {
        _flutterBlue.connectedDevices.then((devices) {
          var deviceList = devices.where((device) {
            return device.name == name;
          }).toList();

          if (deviceList.length > 0) {
            completer.complete(deviceList[0]);
          } else {
            completer.completeError(Failure('not_exists', '指定的名称不存在'));
          }
        }).catchError((error) {
          _postMessage(msg.failure('error', 'connectedDevices 失败'));
        });
      }
    });
    return completer.future;
  }

  _getDeviceState(Message msg) {
    _getDevice(msg).then((device) {
      var stateListen;
      stateListen = device.state.listen((value) {
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
    _log.info('>>>>>>>>>>>>>>>>>>>>>>### _getDevice');
    _getDevice(msg).then((device) {
      _log.info('>>>>>>>>>>>>>>>>>>>>>>>>> _getDevice');
      var stateListen;
      stateListen = device.state.listen((value) {
        _log.info('>>>>>>>>>>>>>>>>>>>>>>>>> device.state.listen');
        stateListen.cancel();

        if (value == BluetoothDeviceState.connected) {
          _postMessage(msg.success(true));
        } else if (value == BluetoothDeviceState.disconnected) {
          _log.info('>>>>>>>>>>>>>>>>>>>>>>### device.connect');
          device
              .connect(autoConnect: true, timeout: Duration(seconds: 30))
              .then((value) {
            _log.info('>>>>>>>>>>>>>>>>>>>>>>>>> device.connect');
            _blueService = BlueService(device);
//            Message message1 = new Message("getSequence", "654321");
//            _blueProtocol.createProtocolCommand(message1);
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

    _getDevice(msg).then((device) {
      var stateListen;
      stateListen = device.state.listen((value) {
        stateListen.cancel();

        if(value == BluetoothDeviceState.disconnected) {
          _postMessage(msg.success(true));
        } else if (value == BluetoothDeviceState.connected) {
          device.disconnect().then((value) {
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

  void disconnect() {
    if (_blueService != null) {
      _blueService.stopListen();
      _blueService = null;
    }
    _flutterBlue.connectedDevices.then((devices) {
      if (devices.length > 0) {
        BluetoothDevice device = devices[0];
        _log.info('*******************${device.name}');
        var stateListen;
        stateListen = device.state.listen((value) {
          stateListen.cancel();
          if (value == BluetoothDeviceState.connected) {
            device.disconnect().then((value) {
            });
          }
        });
      }
    });
  }

  _startListen(Message msg) {
    if (_blueService == null) {
      _postMessage(msg.failure('not_connect', '设备未连接'));
    } else {
      _blueService.startListen((data) {
        String hexString = data.map((val){
          return val.toRadixString(16);
        }).join(' ');

        _log.info('receive: $hexString');
        if (data[0] == 0xAA && data[1] == 0xFF) {
          _log.info('私有蓝牙协议响应: $data');
          _getMsg = _blueProtocol.listen(data);
          if (_getMsg != null) {
            _postMessage(_getMsg);
          }
          /*if (data[2] == 0x06 && _getWiFiStatusMsg != null) {
            Map<String, dynamic> result = Map();
            result['status'] = data[3];
            result['ip'] = '${data[4]}.${data[5]}.${data[6]}.${data[7]}';
            _postMessage(_getWiFiStatusMsg.success(result));
            _getWiFiStatusMsg = null;
          }*/
        } else {
          Message message = Message('onNotify', random());
          message.data = data.join(',');
          _postMessage(message);
        }
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
    }
  }

  _stopListen(Message msg) {
    if (_blueService == null) {
      _postMessage(msg.failure('not_connect', '设备未连接'));
    } else {
      _blueService.stopListen();
      _postMessage(msg.success(true));
    }
  }

  _writeData(Message msg) {
    if (_blueService == null) {
      _postMessage(msg.failure('not_connect', '设备未连接'));
    } else if (!_blueService.listening) {
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

  _setupWiFi(msg) {
    if (_blueService == null) {
      _postMessage(msg.failure('not_connect', '设备未连接'));
    } else if (!_blueService.listening) {
      _postMessage(msg.failure('not_connect', '设备未监听'));
    } else {
      Map<String, dynamic> data = json.decode(msg.data);
      String name = data['name'];
      String password = data['password'];
      String type = data['type'];

      List<List<int>> commands = List<List<int>>();
      commands.addAll(createCommand(name, 1));
      commands.addAll(createCommand(password, 2));
      commands.addAll(createCommand(type, 3));
      _log.info('commands: $commands');
      commands.forEach((command) {
        _blueService.writeData(command);
      });
      _postMessage(msg.success(true));
    }
  }

  _getBlueProtocol(msg) {
    if (_blueService == null) {
      _postMessage(msg.failure('not_connect', '设备未连接'));
    } else if (!_blueService.listening) {
      _postMessage(msg.failure('not_connect', '设备未监听'));
    } else {
      List<int> bytes = _blueProtocol.createProtocolCommand(msg);
      if(bytes == null) {
        _postMessage(msg.failure('not_command', '指令异常'));
      }
      _blueService.writeData(bytes);
      _getMsg = msg;
    }
  }
}
