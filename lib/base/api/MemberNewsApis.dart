import 'package:app/base/AdminRequest.dart';
import 'package:app/base/entity/MemberNews.dart';
import 'package:app/base/util/Page.dart';
import 'package:app/base/util/Result.dart';
import 'package:dio/dio.dart';

class MemberNewsApis {
  static Future<Result<Page<MemberNews>>> getMemberNews(
      int pageIndex, int pageSize, String sortDirection) async {
    try {
      Response response =
          await apiRequest.get("/member-news", queryParameters: {
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'sortDirection': sortDirection,
      });
      Result<Page<MemberNews>> entity = Result.fromJson(
          response.data,
          (data) =>
              Page.fromJson(data, (infoSort) => MemberNews.fromJson(infoSort)));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }
  static Future<Result<MemberNews>> getInfoMemberNews(int newsId) async {
    try {
      Response response = await apiRequest.get('/member-news/news/$newsId');
      Result<MemberNews> entity =
      Result.fromJson(response.data, (data) => MemberNews.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }
  static Future<Result<MemberNews>> getMsgNews(int id) async {
    try {
      Response response = await apiRequest.get('/member-news/$id');
      Result<MemberNews> entity =
      Result.fromJson(response.data, (data) => MemberNews.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return Result(name: err.type.toString(), message: err.message);
    }
  }
}
