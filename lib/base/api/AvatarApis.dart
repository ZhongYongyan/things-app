import 'dart:io';

import 'package:app/base/AdminRequest.dart';
import 'package:app/base/entity/Software.dart';
import 'package:app/base/util/Result.dart';
import 'package:dio/dio.dart';

class AvatarApis {
  static Future<String> getUpload(File image) async {
    try {
      String path = image.path;
      var name = path.substring(path.lastIndexOf("/") + 1, path.length);
      var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(path, filename: name)
      });
      Response response =
          await apiRequest.post('/upload/avatar', data: formData);
      return response.data["data"].toString();
    } on DioError catch (err) {
      return "";
    }
  }
}
