import 'package:app/base/AdminRequest.dart';
import 'package:app/base/entity/AccessToken.dart';
import 'package:app/base/entity/Identity.dart';
import 'package:app/base/entity/HomeBanner.dart';
import 'package:app/base/util/Result.dart';
import 'package:dio/dio.dart';

class AdminApis {
  static Future<Result<AccessToken>> postAccessToken(
      String username, String smsToken, String validCode) async {
    try {
      FormData formData = FormData.fromMap({
//        "companyId": 1362810216906784, //顾家
        "companyId":1351728559554592, //irest
        "clientId": "",
        "phone": username,
        "smsToken": smsToken,
        "validCode": validCode
      });
      Response response = await apiRequest.post("/auth/member/sms/access-token",
          data: formData);

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

  static Future<String> getCode(
      String encoding, String phone, int timestamp) async {
    try {
      FormData formData =  FormData.fromMap({
        "encoding": encoding,
        "phone": phone,
        "timestamp": timestamp,
      });
      Response response = await apiRequest.post("/sms", data: formData);
      return response.data["data"].toString();
    } on DioError catch (err) {
      return "err";
    }
  }

  static Future<BannerResult<HomeBanner>> getBanners(int companyId, int memberId) async {
    try {
      Response response = await apiRequest.get("/banner/bannerurl", queryParameters: {
        'companyId': companyId,
        'memberId': memberId,
      });
      BannerResult<HomeBanner> entity =BannerResult.fromJson(response.data, (data) => HomeBanner.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return BannerResult(name: err.type.toString(), message: err.message);
    }
  }
}

