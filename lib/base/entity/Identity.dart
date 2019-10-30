class Identity {
  String id;
  Map<String, dynamic> claims;
  List<dynamic> roles;
  int expiration;

  Identity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    claims = json['claims'] ?? {};
    roles = json['roles'] ?? [];
    expiration = json['expiration'] ?? 0;
  }
}
