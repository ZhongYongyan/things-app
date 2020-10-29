import 'dart:convert';
import 'dart:io';

import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/config/Settings.dart';
import 'package:app/store/Store.dart';
import 'package:app/store/module/Auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'NavigatorHolder.dart';

// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

_parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class ApiRequest with LoggingMixin {
  Dio create() {
    Store<StoreState> store = StoreConfig.config();

    Dio dio = new Dio();
    dio.options.baseUrl = settings.baseUrl;
    dio.interceptors.add(LogInterceptor(responseBody: false));
    (dio.transformer as DefaultTransformer).jsonDecodeCallback = _parseJson;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (Options options) {
      options.headers.addAll({'client-id': store.state.app.clientId});

      if (options is RequestOptions) {
        RequestOptions ops = options;
        ops.queryParameters.removeWhere((key, value) {
          return value == null;
        });
      }
      if (store.state.auth.isAuth)
        options.headers.addAll(
            {'Authorization': 'Bearer ${store.state.auth.accessToken}'});
    }, onResponse: (Response r) {
      log.info('response: ${r.data}');
    }, onError: (DioError e){
      if (e.response.statusCode == 403 || e.response.statusCode == 401) {
        store.dispatch(authActions.logout());
        navigatorHolder.pushReplacementNamed('/login');
      }
    }));

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };

    return dio;
  }
}

final Dio apiRequest = ApiRequest().create();
