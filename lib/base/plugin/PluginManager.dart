import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class PluginManager {
  Logger _log = Logger('PluginManager');
  Dio _dio = new Dio();

  pluginDirectory() async {
    Directory directory = await getApplicationSupportDirectory();
    Directory pluginsDir = Directory(directory.path + '/plugins');
    return await pluginsDir.create(recursive: true);
  }

  Future<String> download(String url) async {
    String fileName = url.split('/').last;
    String folderName = fileName.split('.').first;

    Directory directory = await pluginDirectory();
    File zipFile = File(directory.path + '/' + fileName);
    if (zipFile.existsSync()) {
      zipFile.deleteSync();
    }

    final destinationDir = Directory(directory.path + '/' + folderName);

    File indexFile = File(destinationDir.path + '/index.html');
    if (indexFile.existsSync()) {
      return 'file://' + indexFile.path + "#/connectBlue";
    }

    if (destinationDir.existsSync()) {
      print("Deleting existing unzip directory: " + destinationDir.path);
      destinationDir.deleteSync(recursive: true);
    }

    destinationDir.createSync();
    _log.info('destinationDir: $destinationDir');

    Response response = await _dio.download(url, zipFile.path);

    await FlutterArchive.unzip(
        zipFile: zipFile, destinationDir: destinationDir);

    _log.info('解压成功, destinationDir: $destinationDir');

    _log.info('download success, path: ${zipFile.path}');
    _log.info('${indexFile.path} ${indexFile.existsSync()}');
    return 'file://' + indexFile.path + "#/connectBlue";
  }

  Future<String> isDownload(String url) async {
    if(url == '') {
      return null;
    }
    String fileName = url.split('/').last;
    String folderName = fileName.split('.').first;

    Directory directory = await pluginDirectory();
    File zipFile = File(directory.path + '/' + fileName);
    if (zipFile.existsSync()) {
      zipFile.deleteSync();
    }

    final destinationDir = Directory(directory.path + '/' + folderName);
    File indexFile = File(destinationDir.path + '/index.html');
    if (indexFile.existsSync()) {
      return 'file://' + indexFile.path + "#/connectBlue";
    }
    return null;
  }
}
