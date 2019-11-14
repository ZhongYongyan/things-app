import 'package:app/base/AdminRequest.dart';
import 'package:app/base/entity/AccessToken.dart';
import 'package:app/base/entity/Identity.dart';
import 'package:app/util/Result.dart';
import 'package:dio/dio.dart';

class AdminApis {
  static Future<Result<AccessToken>> postAccessToken(
      String username, String password) async {
    try {
      Response response = await apiRequest.post("/login/app", data: {
        'phone': username,
        'password': password,
      });

      Result<AccessToken> entity =
          Result.fromJson(response.data, (data) => AccessToken.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }

  static Future<Result<Identity>> getInfo() async {
    try {
      Response response = await apiRequest.get("/account/identity");
      Result<Identity> entity =
          Result.fromJson(response.data, (data) => Identity.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }
}
