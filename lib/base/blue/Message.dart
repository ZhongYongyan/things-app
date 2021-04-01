import 'dart:convert';
import 'dart:math';

class Message {
  String name = '';
  String message = '';
  dynamic data = '';

  String command = '';
  String seq = '';

  Message(String command, String seq) {
    this.command = command;
    this.seq = seq;
  }

  Message.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    message = json['message'] ?? '';
    data = json['data'] ?? '';

    command = json['command'];
    seq = json['seq'] ?? '';
  }

  Map toJson() {
    Map map = new Map();
    map['name'] = this.name;
    map['message'] = this.message;
    map['data'] = this.data;
    map['command'] = this.command;
    map['seq'] = this.seq;
    return map;
  }

  String toJsonString() {
    return json.encode(this);
  }

  Message success(dynamic data) {
    var msg = Message('', this.seq);
    msg.data = data;
    return msg;
  }

  Message failure(String name, String message) {
    var msg = new Message('', this.seq);
    msg.name = name;
    msg.message = message;
    return msg;
  }
}
