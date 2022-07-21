class SignDays {
  int memberId;
  int continueDays;

  SignDays.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'] ?? 0;
    continueDays = json['continueDays'] ?? 0;
  }
}