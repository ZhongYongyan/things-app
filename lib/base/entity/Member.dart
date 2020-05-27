class Member {
  String avatar;
  String city;
  int cityId;
  String clientModel;
  int companyId;
  int id;
  String loginDate;
  String loginIp;
  String password;
  String phone;
  String province;
  int provinceId;
  String registerDate;
  String updated;


  Member.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'] ?? "";
    city = json['city'] ?? "";
    cityId = json['cityId'] ?? 0;
    clientModel = json['clientModel'] ?? "";
    companyId = json['companyId'] ?? 0;
    id = json['id'] ?? "";
    loginDate = json['loginDate'] ?? "";
    loginIp = json['loginIp'] ?? "";
    password = json['password'] ?? "";
    phone = json['phone'] ?? "";
    province = json['province'] ?? "";
    provinceId = json['provinceId'] ?? 0;
    registerDate = json['registerDate'] ?? "";
    updated = json['updated'] ?? "";
  }
}
