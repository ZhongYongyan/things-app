class WarningStatus {
  final String value;

  const WarningStatus(this.value);

  String toJson() => this.value;

  bool operator ==(o) => o is WarningStatus && o.value == value;

  int get hashCode => value.hashCode;

  factory WarningStatus.fromJson(String value) => WarningStatus(value);

  static const WarningStatus Pending = const WarningStatus(''); //待处理
  static const WarningStatus Processing = const WarningStatus('1'); //处理中
  static const WarningStatus Processed = const WarningStatus('2'); //已处理
  static const WarningStatus Closed = const WarningStatus('3'); //关闭
}
