class AppUpdate {
  String Msg;
  int VersionCode;
  int UpdateStatus;
  int ApkSize;
  String ApkMd5;
  String ModifyContent;
  String VersionName;
  int id;
  String DownloadUrl;

  AppUpdate.fromJson(Map<String, dynamic> json) {
    Msg = json['name'] ?? '';
    VersionCode = json['phone'] ?? 0;
    UpdateStatus = json['password'] ?? 0;
    ApkSize = json['created'] ?? 0;
    ApkMd5 = json['createUser'] ?? "";
    ModifyContent = json['ModifyContent'] ?? '';
    VersionName = json['VersionName'];
    id = json['Code'] ?? 0;
    DownloadUrl = json['DownloadUrl'] ?? '';
  }
}
