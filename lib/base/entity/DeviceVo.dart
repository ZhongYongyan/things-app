import 'Device.dart';
import 'DeviceModelAll.dart';
import 'DeviceSort.dart';

class DeviceVo {
  List<DeviceModel> deviceModels;
  List<DeviceSort> deviceSorts;
  List<Device> devices;

  DeviceVo.fromJson(Map<String, dynamic> json) {
    List<dynamic> deviceModel = json['deviceModels'] ?? [];
    List<DeviceModel> deviceData =
        deviceModel.map((item) => DeviceModel.fromJson(item)).toList() ?? [];
    deviceModels = deviceData;

    List<dynamic> deviceSortsModel = json['deviceSorts'] ?? [];
    List<DeviceSort> deviceSortsData =
        deviceSortsModel.map((item) => DeviceSort.fromJson(item)).toList() ?? [];
    deviceSorts = deviceSortsData;

    List<dynamic> devicesModel = json['devices'] ?? [];
    List<Device> devicesData =
        devicesModel.map((item) => Device.fromJson(item)).toList() ?? [];
    devices = devicesData;
  }
}