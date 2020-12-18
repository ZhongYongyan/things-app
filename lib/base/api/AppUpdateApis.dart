import 'package:app/base/AdminRequest.dart';
import 'package:app/base/entity/AppUpdate.dart';
import 'package:app/base/util/Result.dart';
import 'package:dio/dio.dart';

class AppUpdateApis {
  static Future<Result<AppUpdate>> findAppUpdate(int versionCode) async {
    try {
      Response response = await apiRequest.get('/upload/find/appUpdate/$versionCode');
      Result<AppUpdate> entity =
          Result.fromJson(response.data, (data) => AppUpdate.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }
}
