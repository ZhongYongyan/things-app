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
    Msg = json['Msg'] ?? '';
    VersionCode = json['VersionCode'] ?? 0;
    UpdateStatus = json['UpdateStatus'] ?? 0;
    ApkSize = json['ApkSize'] ?? 0;
    ApkMd5 = json['ApkMd5'] ?? '';
    ModifyContent = json['ModifyContent'] ?? '';
    VersionName = json['VersionName'];
    id = json['Code'] ?? 0;
    DownloadUrl = json['DownloadUrl'] ?? '';
  }
}
