import 'dart:async';

import 'package:app/base/blue/Failure.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BlueService {
  BluetoothCharacteristic _writeCharacteristic;
  BluetoothCharacteristic _notifyCharacteristic;
  BluetoothDevice _device;
  StreamSubscription<List<int>> notifyListen;

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
              onData(value);
            }
          });
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
    print('write: ${value}');
    try {
      _writeCharacteristic.write(value, withoutResponse: true);
    } catch (e) {
      print('write ex: ${e}');
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
}
