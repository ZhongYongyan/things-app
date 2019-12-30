class InfoSort {
  int id;
  String name;
  InfoSort.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
  }
}
