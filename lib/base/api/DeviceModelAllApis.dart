import 'package:app/base/AdminRequest.dart';
import 'package:app/base/entity/DeviceModelAll.dart';
import 'package:dio/dio.dart';

class DeviceModelAllApis {
  static Future<DataResult<DeviceModelAll>> getDeviceModelAll() async {
    try {
      Response response = await apiRequest.get("/device-model/all");
      DataResult<DeviceModelAll> entity = DataResult.fromJson(
          response.data, (data) => DeviceModelAll.fromJson(data));
      return entity;

//      DeviceSort deviceSort = new DeviceSort();
//      deviceSort.id = 1;
//      deviceSort.sortName = "sort name";
//      deviceSort.model = new List();
//      deviceSort.model.add(new DeviceSortItem()
//        ..id = 1
//        ..modelName = "model name");
//
//      List<DeviceSort> list = new List();
//      list.add(deviceSort);
//
//      Result<List<DeviceSort>> result = new Result(data: list);
//      return result;

    } on DioError catch (err) {
      return DataResult(name: err.type.toString(), message: err.message);
    }
  }
}
