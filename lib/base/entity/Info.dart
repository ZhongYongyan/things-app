class Info {
  String body;
  int companyId;
  String created;
  bool enable;
  int hits;
  int id;
  List images;
  int sortId;
  String title;
  String updated;

  Info.fromJson(Map<String, dynamic> json) {
    body = json['body'] ?? "";
    companyId = json['companyId'] ?? 0;
    created = json['created'] ?? "";
    enable = json['enable'] ?? false;
    hits = json['hits'] ?? 0;
    id = json['id'] ?? 0;
    images = json['images'] ?? [];
    sortId = json['sortId'] ?? 0;
    title = json['title'] ?? "";
    updated = json['updated'] ?? "";
  }
}
