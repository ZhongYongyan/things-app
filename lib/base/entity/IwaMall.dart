import 'dart:convert';

class IwaMall {
  List<Banners> banner;
  List<Items> items;
  bool ending;

  IwaMall.fromJson(Map<String, dynamic> json) {
    List<dynamic> bannerTemp = json['banner'] ?? [];
    List<Banners> bannerData =
        bannerTemp.map((item) => Banners.fromJson(item)).toList() ?? [];
    banner = bannerData;
    List<dynamic> itemsTemp = json['items'] ?? [];
    List<Items> itemsData =
        itemsTemp.map((item) => Items.fromJson(item)).toList() ?? [];
    items = itemsData;
    ending = json['ending'] ?? true;
  }
}
class Banners {
  int id;
  String pic;
  String link;
  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    pic = json['pic'] ?? "";
    link = json['link'] ?? "";
  }
}

class Items {
  int mid;
  String name;
  int pointPrice;
  String label;
  String pic;
  String saleNum;
  Items.fromJson(Map<String, dynamic> json) {
    mid = json['mid'] ?? 0;
    name = json['name'] ?? "";
    label = json['label'] ?? "";
    pointPrice = json['pointPrice'] ?? 0;
    pic = json['pic'] ?? "";
    saleNum = json['saleNum'];
  }
}
typedef T ObjectDecodeHandler<T>(Map<String, dynamic> data);

class IwaResult<T> {
  IwaResult({this.name, this.message, this.data});

  String name;
  String message;
  T data;

  bool get success {
    return name == null || name.isEmpty || name == "0";
  }

  IwaResult.fromJson(Map<String, dynamic> json, [ObjectDecodeHandler<T> handler]) {
    name = json['name'];
    message = json['message'];
    Map<String,dynamic> dataJson=jsonDecode(json['data']);
    if (dataJson != null && handler != null) {
      data = handler(dataJson);
    }
  }
}

