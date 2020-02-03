import 'package:app/base/AdminRequest.dart';
import 'package:app/base/entity/Affiliate.dart';
import 'package:app/base/util/Page.dart';
import 'package:app/base/util/Result.dart';
import 'package:dio/dio.dart';

class AffiliateApis {
  static Future<Result<Page<Affiliate>>> getAffiliate(
      int pageIndex, int pageSize, String sortDirection) async {
    try {
      Response response = await apiRequest.get("/affiliate", queryParameters: {
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'sortDirection': sortDirection,
        'memberId': 10,
      });
      Result<Page<Affiliate>> entity = Result.fromJson(
          response.data,
          (data) =>
              Page.fromJson(data, (infoSort) => Affiliate.fromJson(infoSort)));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }

  static Future<Result<Affiliate>> modifyAffiliate(Affiliate affiliate) async {
    try {
      var id = affiliate.id;
      FormData formData = new FormData.from({
        'birthday': affiliate.birthday,
        'height': affiliate.height,
        'id': affiliate.id,
        'nickname': affiliate.nickname,
        'phone': affiliate.phone,
        'sex': affiliate.sex,
        'weight': affiliate.weight,
      });
      var responseUrl;
      if (id != 0) {
        //修改
        responseUrl = await apiRequest.put("/affiliate/$id", data: formData);
      } else {
        //添加
        responseUrl = await apiRequest.post("/affiliate", data: formData);
      }
      Response response = responseUrl;
      Result<Affiliate> entity =
          Result.fromJson(response.data, (data) => Affiliate.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }

  static Future<Result<Affiliate>> addAffiliate(Affiliate affiliate) async {
    try {
      FormData formData = new FormData.from({
        'birthday': affiliate.birthday,
        'height': affiliate.height,
        'nickname': affiliate.nickname,
        'phone': affiliate.phone,
        'sex': affiliate.sex,
        'weight': affiliate.weight,
      });
      Response response = await apiRequest.post("/affiliate", data: formData);
      Result<Affiliate> entity =
          Result.fromJson(response.data, (data) => Affiliate.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }

  static Future<Result<Affiliate>> delAffiliate(Affiliate affiliate) async {
    try {
      var id = affiliate.id;
      Response response = await apiRequest.delete("/affiliate/$id");
      Result<Affiliate> entity =
          Result.fromJson(response.data, (data) => Affiliate.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }
}
