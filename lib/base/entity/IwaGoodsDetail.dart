class IwaGoodsDetail {
  List<GoodsDetail> goodsDetail;
  List<String> banners;
  List<String> detailPics;
  int saleNum;

  IwaGoodsDetail.fromJson(Map<String, dynamic> json) {
    List<dynamic> goodsDetailTemp = json['goodsDetail']??[];
    List<GoodsDetail> goodsData =
        goodsDetailTemp.map((item) => GoodsDetail.fromJson(item)).toList() ?? [];
    List<dynamic> _banners = json['banners'];
    banners = _banners.map((x) => x as String).toList();
    List<dynamic> _detailPics = json['detailPics'];
    detailPics = _detailPics.map((x) => x as String).toList();
    goodsDetail = goodsData;
    saleNum = json['saleNum'] ?? 0;
  }
}

class GoodsDetail {
  String id;
  String name;
  String color;
  String img;
  int pointPrice;
  int quantity=1;
  GoodsDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    color = json['color'] ?? "";
    img = json['img'] ?? "";
    pointPrice = json['pointPrice'] ?? "";
  }
}
