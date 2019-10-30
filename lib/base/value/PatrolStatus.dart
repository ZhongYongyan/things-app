class PatrolStatus {
  final int value;

  const PatrolStatus(this.value);

  int toJson() => this.value;

  bool operator ==(o) => o is PatrolStatus && o.value == value;

  int get hashCode => value.hashCode;

  factory PatrolStatus.fromJson(int value) => PatrolStatus(value);

  static const PatrolStatus Success = const PatrolStatus(1); //签到成功
  static const PatrolStatus Failure = const PatrolStatus(2); //签到失败
}
