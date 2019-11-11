import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
class Http {
  post(url, data) async {
    Dio dio = new Dio();
    dio.options.baseUrl = 'https://api.apiopen.top';
    dio.options.headers.addAll({
      'AppCode': 'THINGS',
      'ClientId': '58ef798fe70f4cc59610d73471b23051',
    });
    try {
      var response = await dio.post(url, data: data);
      var code = response.data['code'];
      if (code == 200) {
        return response.data["result"];
      } else {
        Fluttertoast.showToast(
            msg: "出错啦~",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 2,
            backgroundColor: Color(0xFF3578F7),
            textColor: Colors.white,
            fontSize: 14.0
        );
        return [];
      }
    }catch (exception) {
      Fluttertoast.showToast(
          msg: exception.type == DioErrorType.DEFAULT ? "无网络~" : exception.type == DioErrorType.CONNECT_TIMEOUT ? "连接超时~" : "服务器错误~",
          toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          backgroundColor: Color(0xFF3578F7),
          textColor: Colors.white,
          fontSize: 14.0
      );
      return [];
    }
  }

  get(index) async {
    var response =
        await Http().post("/musicBroadcasting", {});
    return response;
  }
}
