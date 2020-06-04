import 'package:app/base/entity/DeviceVo.dart';
import 'package:app/base/entity/Member.dart';
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
      FormData formData = new FormData.from({
        "avatar": path,
      });
      Response response =
          await apiRequest.put('/member/avatar', data: formData);
      return response.data["data"].toString();
    } on DioError catch (err) {
      return "err";
    }
  }
}
