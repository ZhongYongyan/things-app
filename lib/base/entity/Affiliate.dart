class Affiliate {
  String birthday;
  String created;
  int height;
  int id;
  int memberId;
  String nickname;
  String phone;
  String sex;
  int weight;
  Affiliate.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'] ?? "";
    created = json['created'] ?? "";
    height = json['height'] ?? 0;
    id = json['id'] ?? -1;
    memberId = json['memberId'] ?? 0;
    nickname = json['nickname'] ?? "";
    phone = json['phone'] ?? "";
    sex = json['sex'] ?? "";
    weight = json['weight'] ?? 0;
  }
}
