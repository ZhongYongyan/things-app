class AccessToken {
  String accessToken;

  AccessToken.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'] ?? '';
  }
}
