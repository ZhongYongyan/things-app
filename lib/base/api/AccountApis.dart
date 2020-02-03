import 'package:app/base/AdminRequest.dart';
import 'package:app/base/entity/Account.dart';
import 'package:app/base/entity/Identity.dart';
import 'package:app/base/util/Result.dart';
import 'package:dio/dio.dart';

class AccountApis {
  static Future<Result<Account>> getAccount(int id) async {
    try {
      Response response = await apiRequest.get('/account/$id');
      Result<Account> entity =
          Result.fromJson(response.data, (data) => Account.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }

  static Future<Result<Identity>> getIdentity() async {
    try {
      Response response = await apiRequest.get('/account/identity');
      Result<Identity> entity =
          Result.fromJson(response.data, (data) => Identity.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }
}
