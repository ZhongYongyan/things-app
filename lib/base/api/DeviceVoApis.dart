import 'package:app/base/entity/DeviceVo.dart';
import 'package:app/base/util/Result.dart';
import 'package:dio/dio.dart';

import '../AdminRequest.dart';

class DeviceVoApis {
  static Future<Result<DeviceVo>> getDeviceVo() async {
    try {
      Response response = await apiRequest.get("/member-device/member");
      Result<DeviceVo> entity =
      Result.fromJson(response.data, (data) => DeviceVo.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }
}