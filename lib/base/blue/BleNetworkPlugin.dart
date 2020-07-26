import 'package:flutter/services.dart';

typedef void EventHandler(Object event);

class BleNetworkPlugin {
  static const MethodChannel _channel = const MethodChannel('blenetworkplugin_plugin');

  static Future<String> configNetworkForRemoteDevice(String ssid, String password, String name) async {
    return await _channel
        .invokeMethod('configNetworkForRemoteDevice', {'ssid': ssid, 'password': password, 'name': name});
  }

  static Future<void> startScan() async {
    return await _channel.invokeMethod('startScan', {});
  }

  static Future<void> stopScan() async {
    return await _channel.invokeMethod('stopScan', {});
  }

  static Future<void> setup(String ssid, String password, String name) async {
    return await _channel.invokeMethod('setup', {'ssid': ssid, 'password': password, 'name': name});
  }
}
