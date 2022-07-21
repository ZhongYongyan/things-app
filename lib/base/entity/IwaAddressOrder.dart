import 'dart:convert';
class IwaAddressOrder{
  List<Items> items;
  bool over;
  IwaAddressOrder.fromJson(Map<String, dynamic> json) {
    List<dynamic> itemsTemp = json['items'];
    List<Items> itemsData =
        itemsTemp.map((item) => Items.fromJson(item)).toList() ?? [];
    items = itemsData;
    over = json['over'];
  }
}

class Items {
  int id;
  String orderNum;
  int address;
  String sTime;
  String cTime;
  int stage;
  String remark;
  int orderPoints;
  List<Details> details;
  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    orderNum = json['orderNum'] ?? "";
    address = json['address'] ?? "";
    sTime = json['sTime'] ?? "";
    cTime = json['cTime'] ?? "";
    stage = json['stage'] ?? 0;
    remark = json['remark'] ?? "";
    orderPoints = json['orderPoints'] ?? 0;
  }

}

class Details{
  int num;
  int pointPrice;
  String pic;
  String name;
  String label;
  Details.fromJson(Map<String, dynamic> json) {
    num = json['num'] ?? 0;
    pointPrice = json['pointPrice'] ?? 0;
    pic = json['pic'] ?? "";
    name = json['name'] ?? "";
    label = json['label'];
  }
}
