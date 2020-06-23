import 'package:app/base/AdminRequest.dart';
import 'package:app/base/entity/Software.dart';
import 'package:app/base/util/Result.dart';
import 'package:dio/dio.dart';

class SoftwareApis {
  static Future<Result<Software>> getSoftware(int modelId) async {
    try {
      Response response =
          await apiRequest.get('/software/model/$modelId', queryParameters: {
        'modelId': modelId,'firmwareVersions':1.0,
      });
      Result<Software> entity =
          Result.fromJson(response.data, (data) => Software.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }
}
