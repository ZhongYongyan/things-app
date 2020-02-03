import 'package:app/base/util/Result.dart';

class DeviceModelAll {
  DeviceModelAll() {}
  int id;
  String sortName;
  List<DeviceModel> model;

  DeviceModelAll.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    sortName = json['sortName'] ?? "";
    List<dynamic> models = json['model'];
    List<DeviceModel> data =
        models.map((item) => DeviceModel.fromJson(item)).toList() ?? [];
    model = data;
  }
}

class DeviceModel {
  DeviceModel() {}

  int id;
  String modelName;
  int sortId;
  int companyId;
  String modelIcon;
  bool isFirmware;
  bool isSoftware;
  bool isSelfMotion;
  int sort;
  String created;
  String updated;

  DeviceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    modelName = json['modelName'] ?? "";
    sortId = json['sortId'] ?? 0;
    companyId = json['companyId'] ?? 0;
    modelIcon = json['modelIcon'] ?? "";
    isFirmware = json['isFirmware'] ?? false;
    isSoftware = json['isSoftware'] ?? false;
    isSelfMotion = json['isSelfMotion'] ?? false;
    sort = json['sort'] ?? 0;
    created = json['created'] ?? "";
    updated = json['updated'] ?? "";
  }
}

class DataResult<T> {
  DataResult({this.name, this.message, this.data});

  String name;
  String message;
  List<T> data;

  bool get success {
    return name == null || name.isEmpty || name == "0";
  }

  DataResult.fromJson(Map<String, dynamic> json,
      [ObjectDecodeHandler<T> handler]) {
    name = json['name'];
    message = json['message'];

    List<dynamic> dataJson = json['data'];
    if (dataJson != null && handler != null) {
      var result = dataJson.map((item) {
        return handler(item);
      });
      data = result.toList();
    }
  }
}
