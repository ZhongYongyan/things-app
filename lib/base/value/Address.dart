class AddressItem {
  String code;
  String name;

  AddressItem(this.code, this.name);
}

class Address {
  List<AddressItem> items;
  String lat;
  String lng;
  String detail;

  Address(this.items, this.lat, this.lng, this.detail);

  Address.fromJson(Map<String, dynamic> json) {
    lat = json['lat'] ?? 0;
    lng = json['lng'] ?? 0;
    detail = json['detail'] ?? '';

    List<dynamic> list = json['items'];
    if (list != null) {
      items = list.map((x) {
        return AddressItem(x['code'] ?? '', x['name' ?? '']);
      }).toList();
    }
  }
}
