class MemberNews {
  String body;
  String created;
  int id;
  List images;
  int memberId;
  String newsStatus;
  String title;
  String updated;
  String actions;
  String actionData;
  int newsId;

  MemberNews.fromJson(Map<String, dynamic> json) {
    body = json['body'] ?? "";
    created = json['created'] ?? "";
    id = json['id'] ?? 0;
    images = json['images'] ?? [];
    memberId = json['memberId'] ?? 0;
    newsStatus = json['newsStatus'] ?? "";
    actions = json['actions'] ?? "";
    actionData = json['actionData'] ?? "";
    title = json['title'] ?? "";
    updated = json['updated'] ?? "";
    newsId = json['newsId'] ?? 0;
  }
}
