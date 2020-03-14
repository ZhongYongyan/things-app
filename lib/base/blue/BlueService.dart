import 'package:flutter_blue/flutter_blue.dart';

class BleService {
  static BleService Default = BleService();

  BluetoothCharacteristic _writeCharacteristic;
  BluetoothCharacteristic _notifyCharacteristic;

  bool get found {
    return _writeCharacteristic != null && _notifyCharacteristic != null;
  }

  start(void onDone(), Function onError) {
    FlutterBlue flutterBlue = FlutterBlue.instance;

    BluetoothDevice device;

    flutterBlue.startScan(timeout: Duration(seconds: 60));
    flutterBlue.scanResults.listen((scanResult) {
      scanResult.forEach((x) {
        print(x.device.name);
      });

      List<ScanResult> list = scanResult.where((x) {
        return x.device.name.startsWith('aispeech');
      }).toList();

      if (list.isNotEmpty) {
        flutterBlue.stopScan();
        if (device == null) {
          device = list.first.device;
          device.connect().then((x) {
            device.discoverServices().then((services) {
              services.forEach((service) {
                print('service.uuid:${service.uuid}');
                if (service.uuid.toString() ==
                    '0000fff0-0000-1000-8000-00805f9b34fb') {
                  var characteristics = service.characteristics;
                  for (BluetoothCharacteristic characteristic
                      in characteristics) {
                    if (_writeCharacteristic == null)
                      _checkWriteCharacteristic(characteristic);

                    if (_notifyCharacteristic == null)
                      _checkNotifyCharacteristic(characteristic);

                    if (_writeCharacteristic != null &&
                        _notifyCharacteristic != null) {
                      onDone();
                    }
                  }
                }
              });
            });
          });
        }
      }
    }, onError: (error) {
      print('onError: $error}');
      onError();
    }, onDone: () {
      print('onDone');
      if (_notifyCharacteristic == null || _writeCharacteristic == null)
        onError();
    });
  }

  listen(void onData(List<int> event)) {
    _notifyCharacteristic.setNotifyValue(true);
    _notifyCharacteristic.value.listen((value) {
      onData(value);
    });
  }

  void write(List<int> value) {
    print('write: ${value}');
    _writeCharacteristic.write(value);
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
