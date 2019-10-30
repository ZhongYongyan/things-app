class Account {
  int id;
  String name;
  String phone;
  String password;
  int created;
  int createUser;
  int updated;
  List<int> roles;
  String workNumber;
  String avatar;

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    phone = json['phone'] ?? '';
    password = json['password'] ?? '';
    created = json['created'] ?? 0;
    createUser = json['createUser'] ?? 0;
    updated = json['updated'] ?? 0;
    List<dynamic> _roles = json['roles'];
    roles = _roles.map((x) => x as int).toList();
    workNumber = json['workNumber'] ?? '';
    avatar = json['avatar'] ?? '';
  }
}
