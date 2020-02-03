class MemberNews {
  String body;
  String created;
  int id;
  List images;
  int memberId;
  String newsStatus;
  String targetLinks;
  String targetType;
  String title;
  String updated;

  MemberNews.fromJson(Map<String, dynamic> json) {
    body = json['body'] ?? "";
    created = json['created'] ?? "";
    id = json['id'] ?? 0;
    images = json['images'] ?? [];
    memberId = json['memberId'] ?? 0;
    newsStatus = json['newsStatus'] ?? "";
    targetLinks = json['targetLinks'] ?? "";
    targetType = json['targetType'] ?? "";
    title = json['title'] ?? "";
    updated = json['updated'] ?? "";
  }
}
