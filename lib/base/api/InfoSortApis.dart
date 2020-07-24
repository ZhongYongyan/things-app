import 'package:app/base/AdminRequest.dart';
import 'package:app/base/entity/Info.dart';
import 'package:app/base/entity/InfoSort.dart';
import 'package:app/base/util/Page.dart';
import 'package:app/base/util/Result.dart';
import 'package:dio/dio.dart';

class InfoSortApis {
  static Future<Result<Page<InfoSort>>> getInfoSort(
      int pageIndex, int pageSize, String sortDirection) async {
    try {
      Response response = await apiRequest.get("/info-sort", queryParameters: {
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'sortDirection': sortDirection,
        'sortProperties': 'sort'
      });
      Result<Page<InfoSort>> entity = Result.fromJson(
          response.data,
          (data) =>
              Page.fromJson(data, (infoSort) => InfoSort.fromJson(infoSort)));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }

  static Future<Result<Info>> getDelInfoSort(int id) async {
    try {
      Response response = await apiRequest.get('/info/$id');
      Result<Info> entity =
          Result.fromJson(response.data, (data) => Info.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }

  static Future<Result<Page<Info>>> getInfo(
      int pageIndex, int pageSize, String sortDirection, int sortId) async {
    try {
      Response response = await apiRequest.get("/info", queryParameters: {
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'sortDirection': sortDirection,
        'sortId': sortId
      });
      Result<Page<Info>> entity = Result.fromJson(response.data,
          (data) => Page.fromJson(data, (infoSort) => Info.fromJson(infoSort)));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }
}
