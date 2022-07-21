import 'dart:convert';

class IwaAddress {
  IwaAddress();
  int id;
  String name;
  String phone;
  String province;
  String city;
  String area;
  String street;
  bool isDefault;
  IwaAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    phone = json['phone'] ?? "";
    province = json['province'] ?? "";
    city = json['city'] ?? "";
    area = json['area'] ?? "";
    street = json['street'] ?? "";
    isDefault = json['isDefault'] ?? false;
  }

  Map toJson() {
    Map map = new Map();
    map["id"] = this.id;
    map["name"] = this.name;
    map["phone"] = this.phone;
    map["province"] = this.province;
    map["city"] = this.city;
    map["area"] = this.area;
    map["street"] = this.street;
    map["isDefault"] = this.isDefault;
    return map;
  }

  static IwaAddress fromMap(Map<String,dynamic> map){
    IwaAddress iwaAddress = new IwaAddress();
    iwaAddress.id=map["id"];
    iwaAddress.name=map["name"];
    iwaAddress.phone=map["phone"];
    iwaAddress.province=map["province"];
    iwaAddress.city=map["city"];
    iwaAddress.area=map["area"];
    iwaAddress.street=map["street"];
    iwaAddress.isDefault=map["isDefault"];
    return iwaAddress;
  }

  static IwaAddress parseJson(String jsonStr){
    IwaAddress result = IwaAddress.fromMap(jsonDecode(jsonStr));
    return result;
  }
}

class IwaFormat{
  int errCode;
  List<IwaAddress> errMsg;
  IwaFormat.fromJson(Map<String, dynamic> json) {
    List<dynamic> addressTemp = json['errMsg']??[];
    List<IwaAddress> addressData =
        addressTemp.map((item) => IwaAddress.fromJson(item)).toList() ?? [];
    errMsg = addressData;
    errCode = json['errCode'] ?? 0;
  }
}
