class DeviceSort {
  String created;
  int id;
  int sort;
  String sortName;
  String updated;

  DeviceSort.fromJson(Map<String, dynamic> json) {
    created = json['created'] ?? "";
    id = json['id'] ?? 0;
    sort = json['sort'] ?? 0;
    sortName = json['sortName'] ?? "";
    updated = json['updated'] ?? "";
  }
}
