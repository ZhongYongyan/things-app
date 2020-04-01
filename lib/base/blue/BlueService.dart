import 'dart:async';

import 'package:app/base/blue/Failure.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BlueService {
  BluetoothCharacteristic _writeCharacteristic;
  BluetoothCharacteristic _notifyCharacteristic;
  BluetoothDevice _device;
  StreamSubscription<List<int>> notifyListen;
  List<int> _received = List<int>();

  /// 发送命令队列
  List<List<int>> _queue = List();

  BlueService(BluetoothDevice device) {
    _device = device;
  }

  Future<void> startListen(void onData(List<int> event)) {
    Completer<void> completer = new Completer<void>();
    if (_writeCharacteristic == null && _notifyCharacteristic == null) {
      _device.discoverServices().then((services) {
        services.forEach((service) {
          print('service.uuid:${service.uuid}');
          if (service.uuid.toString() ==
              '0000fff0-0000-1000-8000-00805f9b34fb') {
            var characteristics = service.characteristics;
            for (BluetoothCharacteristic characteristic in characteristics) {
              if (_writeCharacteristic == null)
                _checkWriteCharacteristic(characteristic);

              if (_notifyCharacteristic == null)
                _checkNotifyCharacteristic(characteristic);
            }
          }
        });

        if (_writeCharacteristic != null && _notifyCharacteristic != null) {
          _notifyCharacteristic.setNotifyValue(true);
          notifyListen = _notifyCharacteristic.value.listen((value) {
            if (value != null && value.length > 0) {
              _received.addAll(value);

              List<List<int>> commands = _handleReceived(
                  _received.getRange(0, _received.length).toList());
              commands.forEach((command) {
                _received.removeRange(0, command.length);
                Future.delayed(Duration(milliseconds: 10), () {
                  onData(command);
                });
              });
            }
          });
          queueWrite();
          completer.complete();
        } else {
          completer.completeError(Failure('service_invalid', '读写服务没有找到'));
        }
      }).catchError((error) {
        completer.completeError(Failure('service_invalid', '读写服务不可用'));
      });
    } else {
      completer.completeError(Failure('already_listened', '已开启监听数据'));
    }
    return completer.future;
  }

  stopListen() {
    if (_writeCharacteristic != null && _notifyCharacteristic != null) {
      _notifyCharacteristic.setNotifyValue(false);
      notifyListen.cancel();
      notifyListen = null;

      _writeCharacteristic = null;
      _notifyCharacteristic = null;
    }
  }

  get listening {
    return _writeCharacteristic != null && _notifyCharacteristic != null;
  }

  void writeData(List<int> value) {
    _queue.add(value);
  }

  queueWrite() {
    if (_queue.isNotEmpty) {
      List<int> data = _queue[0];
      _queue.removeAt(0);

      if (_writeCharacteristic != null) {
        print('write: ${data}');
        _writeCharacteristic.write(data, withoutResponse: true);
      }
    }

    if (_writeCharacteristic != null) {
      Future.delayed(Duration(milliseconds: 100), () {
        queueWrite();
      });
    }
  }

  _checkWriteCharacteristic(BluetoothCharacteristic characteristic) {
    if (characteristic.uuid.toString() ==
        '0000fff1-0000-1000-8000-00805f9b34fb') {
      print('${characteristic.uuid} characteristic:write');
      _writeCharacteristic = characteristic;
    }
  }

  _checkNotifyCharacteristic(BluetoothCharacteristic characteristic) {
    if (characteristic.uuid.toString() ==
        "0734594a-a8e7-4b1a-a6b1-cd5243059a57") {
      print('${characteristic.uuid} characteristic:notify');
      _notifyCharacteristic = characteristic;
    }
  }

  List<List<int>> _handleReceived(List<int> received) {
    List<List<int>> commands = new List<List<int>>();
    List<int> data = List<int>();
    bool start = false;
    while (received.isNotEmpty) {
      int byte = received.removeAt(0);
      if (start) {
        if (byte == 0x0D) {
          if (received.isNotEmpty && received[0] == 0x0A) {
            data.add(byte);
            data.add(received.removeAt(0));

            commands.add(data.getRange(0, data.length).toList());

            start = false;
            data.clear();
          } else {
            data.add(byte);
          }
        } else {
          data.add(byte);
        }
      } else if (byte == 0xAA && received[0] == 0x55) {
        start = true;
        data.add(byte);
      }
    }

    return commands;
  }
}
