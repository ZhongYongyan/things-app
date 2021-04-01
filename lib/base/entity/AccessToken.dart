class AccessToken {
  String accessToken;

  AccessToken.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'] ?? '';
  }
}
