import 'dart:io';

import 'package:app/base/util/LoggingUtils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';

class PluginManager with LoggingMixin {
  Dio dio = new Dio();

  pluginDirectory() async {
    Directory directory = await getApplicationSupportDirectory();
    Directory pluginsDir = Directory(directory.path + '/plugins');
    return await pluginsDir.create(recursive: true);
  }

  Future<Response> download() async {
    Directory directory = await pluginDirectory();
    String path = directory.path + '/things-plugin-a800.zip';
    Response response = await dio.download(
        "http://dev.mp.hswl007.com/things-plugin-a800.zip", path);

    final zipFile = File(path);
    final destinationDir = Directory(directory.path);
    try {
      FlutterArchive.unzip(zipFile: zipFile, destinationDir: destinationDir);
    } catch (e) {
      print(e);
    }

    log.info('download success, path: $path');
    return response;
  }
}
