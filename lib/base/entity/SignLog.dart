class SignLog {
  int logId;
  int memberId;
  String created;

  SignLog.fromJson(Map<String, dynamic> json) {
    logId = json['logId'] ?? 0;
    memberId = json['memberId'] ?? 0;
    created = json['created'] ?? "";
  }
}