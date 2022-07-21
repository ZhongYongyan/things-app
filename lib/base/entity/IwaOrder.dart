class IwaOrder{
  List<Items> items;
  bool over;
  IwaOrder.fromJson(Map<String, dynamic> json) {
    List<dynamic> itemsTemp = json['items']??[];
    List<Items> itemsData =
        itemsTemp.map((item) => Items.fromJson(item)).toList() ?? [];
    items = itemsData;
    over=json['over']??true;
  }
}

class Items {
  int id;
  String orderNum;
  int aid;
  String totalPoints;
  String sTime;
  String cTime;
  int stage;
  String status;
  String remark;
  List<Details> details;
  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    orderNum = json['orderNum'] ?? "";
    totalPoints = json['totalPoints'] ?? '0';
    aid = json['aid'] ?? 0;
    sTime = json['sTime'] ?? "";
    cTime = json['cTime'] ?? "";
    stage = json['stage'] ?? 0;
    status = json['status'] ?? '';
    remark = json['remark'] ?? "";
    List<dynamic> detailTemp = json['details'];
    List<Details> detailData =
        detailTemp.map((item) => Details.fromJson(item)).toList() ?? [];
    details = detailData;
  }

}

class Details{
  String num;
  int pointPrice;
  String img;
  String name;
  String label;
  Details.fromJson(Map<String, dynamic> json) {
    num = json['num'] ?? '0';
    pointPrice = json['pointPrice'] ?? 0;
    img = json['img'] ?? "";
    name = json['name'] ?? "";
    label = json['label'];
  }
}