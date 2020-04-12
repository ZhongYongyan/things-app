class Software {
  int accountId;
  String accountName;
  int companyId;
  String created;
  String describe;
  String extName;
  int firmwareId;
  int id;
  String issueStatus;
  int modelId;
  int sortId;
  String updated;
  String url;
  String versions;


  Software.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'] ?? "";
    accountName = json['accountName'] ?? "";
    companyId = json['companyId'] ?? 0;
    created = json['created'] ?? "";
    describe = json['describe'] ?? "";
    extName = json['extName'] ?? "";
    firmwareId = json['firmwareId'] ?? 0;
    id = json['id'] ?? 0;
    issueStatus = json['issueStatus'] ?? "";
    modelId = json['modelId'] ?? 0;
    sortId = json['sortId'] ?? 0;
    updated = json['updated'] ?? "";
    url = json['url'] ?? "";
    versions = json['versions'] ?? "";
  }
}
