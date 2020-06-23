class TicketStatus {
  String value;

  TicketStatus(this.value);

  String toJson() => this.value;

  bool operator ==(o) => o is TicketStatus && o.value == value;

  int get hashCode => value.hashCode;

  factory TicketStatus.fromJson(String value) => TicketStatus(value);

  static final TicketStatus Pending = TicketStatus(''); //待处理
  static final TicketStatus Processing = TicketStatus('1'); //无线网关
  static final TicketStatus Processed = TicketStatus('2'); //微站网关
  static final TicketStatus Suspend = TicketStatus('3'); //挂起
}
