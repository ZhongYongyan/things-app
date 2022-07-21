// import 'package:app/base/util/Result.dart';
typedef T ObjectDecodeHandler<T>(Map<String, dynamic> data);
class HomeBanner {
  HomeBanner(){}
  String imageurl;
  String linkurl;
  int sort;

  HomeBanner.fromJson(Map<String, dynamic> json) {
    imageurl = json['imageurl'] ?? '';
    linkurl = json['linkurl'] ?? '';
    sort = json['sort'] ?? 0;
  }
}

// class HomeBannerItem {
//   HomeBannerItem(){}
//   Map<String,dynamic> data;
//   HomeBannerItem.fromJson(Map<String, dynamic> json) {
//     List<dynamic> models = json['data'];
//     List<HomeBanner> data =
//         models.map((item) => HomeBanner.fromJson(item)).toList() ?? [];
//     data = data;
//   }
// }

class BannerResult<T> {
  BannerResult({this.name, this.message, this.data});

  String name;
  String message;
  List<T> data;

  bool get success {
    return name == null || name.isEmpty || name == "0";
  }

  BannerResult.fromJson(Map<String, dynamic> json,
      [ObjectDecodeHandler<T> handler]) {
    name = json['name'];
    message = json['message'];
    List<dynamic> dataJson = json['data'];
    if (dataJson != null && handler != null) {
      print(handler);
      var result = dataJson.map((item) {
        return handler(item);
      });
      data = result.toList();
    }
  }
}