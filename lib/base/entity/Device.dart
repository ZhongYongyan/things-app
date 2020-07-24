class Device {
  int agentId;
  String city;
  int cityId;
  int companyId;
  String created;
  String deviceSn;
  int id;
  int modelId;
  String province;
  int provinceId;
  int sortId;
  String statusCode;
  String statusMeg;
  String statusUpdateTime;
  String statusMupdatedeg;
  bool loadShow = false;
  String blueName;
  bool isDelete = false;

  Device.fromJson(Map<String, dynamic> json) {
    agentId = json['agentId'] ?? 0;
    city = json['city'] ?? "";
    cityId = json['cityId'] ?? "";
    companyId = json['companyId'] ?? 0;
    created = json['created'] ?? "";
    deviceSn = json['deviceSn'] ?? "";
    id = json['id'] ?? 0;
    modelId = json['modelId'] ?? 0;
    province = json['province'] ?? "";
    provinceId = json['provinceId'] ?? "";
    sortId = json['sortId'] ?? 0;
    statusCode = json['statusCode'] ?? "";
    statusMeg = json['statusMeg'] ?? "";
    statusUpdateTime = json['statusUpdateTime'] ?? "";
    statusMupdatedeg = json['statusMupdatedeg'] ?? "";
    blueName = json['blueName'] ?? "";
  }
}
