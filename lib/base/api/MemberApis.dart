import 'package:app/base/entity/Affiliate.dart';
import 'package:app/base/entity/Member.dart';
import 'package:app/base/entity/MemberInfo.dart';
import 'package:app/base/entity/SignDays.dart';
import 'package:app/base/entity/SignLog.dart';
import 'package:app/base/util/Paged.dart';
import 'package:app/base/util/Result.dart';
import 'package:dio/dio.dart';

import '../AdminRequest.dart';

class MemberApis {
  static Future<Result<Member>> getMember() async {
    try {
      Response response = await apiRequest.get("/member/login");
      Result<Member> entity =
          Result.fromJson(response.data, (data) => Member.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }

  static Future<String> setAvatar(String path) async {
    try {
      FormData formData = FormData.fromMap({
        "avatar": path,
      });
      Response response =
          await apiRequest.put('/member/avatar', data: formData);
      return response.data["data"].toString();
    } on DioError catch (err) {
      return "err";
    }
  }

  /*
   * 2022.05.28，zhou，获取个人详细信息
   */
  static Future<Result<MemberInfo>> getMemberInfo(int memberId) async {
    try {
      Response response = await apiRequest.get("/member-info/$memberId");
      Result<MemberInfo> entity = Result.fromJson(
          response.data,
              (data) =>MemberInfo.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }


  /*
   * 2022.06.09，zhou，测试获取数据
   */
  // static Future<Result<Paged<Colour>>> getTestall(
  //     int pageIndex, int pageSize, String sortDirection) async {
  //   try {
  //     Response response = await apiRequest.get("/colour", queryParameters: {
  //       'pageIndex': pageIndex,
  //       'pageSize': pageSize,
  //       'sortDirection': sortDirection,
  //     });
  //     Result<Paged<Colour>> entity = Result.fromJson(
  //         response.data,
  //             (data) =>
  //             Paged.fromJson(data, (infoSort) => Colour.fromJson(infoSort)));
  //     return entity;
  //   } on DioError catch (err) {
  //     return Result(name: err.type.toString(), message: err.message);
  //   }
  // }
  static Future<Result<Paged<SignLog>>> getTestall(
      int pageIndex, int pageSize, String sortDirection, String memberId, String createBegin, String createEnd) async {
    try {
      Response response = await apiRequest.get("/sign-log", queryParameters: {
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'sortDirection': sortDirection,
        'memberId': memberId,
        'createBegin': createBegin,
        'createEnd': createEnd,
      });
      Result<Paged<SignLog>> entity = Result.fromJson(
          response.data,
              (data) =>
              Paged.fromJson(data, (infoSort) => SignLog.fromJson(infoSort)));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }


  static Future<Result<SignDays>> getSignDays(int memberId) async {
    try {
      Response response = await apiRequest.get('/sign-log/$memberId');
      Result<SignDays> entity =
      Result.fromJson(response.data, (data) => SignDays.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }


  /*
   * 2022.05.30，zhou，修改个人详细信息
   */

}
