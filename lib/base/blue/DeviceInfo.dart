import 'dart:convert';
import 'dart:math';

import 'package:flutter_blue/flutter_blue.dart';

class DeviceInfo {
  String name = '';
  BluetoothDeviceState state;

  DeviceInfo(String name, BluetoothDeviceState state) {
    this.name = name;
    this.state = state;
  }

  Map toJson() {
    Map map = new Map();
    map['name'] = this.name;
    map['state'] = this.state;
    return map;
  }
}
