import 'package:flutter/services.dart';

typedef void EventHandler(Object event);

class BleNetworkPlugin {
  static const MethodChannel _channel =
      const MethodChannel('blenetworkplugin_plugin');

  static Future<String> configNetworkForRemoteDevice(
      String ssid, String password, String name) async {
    return await _channel.invokeMethod('configNetworkForRemoteDevice',
        {'ssid': ssid, 'password': password, 'name': name});
  }
}
