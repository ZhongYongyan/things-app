// class MemberInfo {
//   String birthday;
//   String created;
//   int height;
//   int id;
//   int memberId;
//   String nickname;
//   String phone;
//   String sex;
//   double weight;
//   String avatar;
//
//   MemberInfo.fromJson(Map<String, dynamic> json) {
//     birthday = json['birthday'] ?? "";
//     created = json['created'] ?? "";
//     height = json['height'] ?? 0;
//     id = json['id'] ?? 0;
//     memberId = json['memberId'] ?? 0;
//     nickname = json['nickname'] ?? "";
//     phone = json['phone'] ?? "";
//     sex = json['sex'] ?? "";
//     weight = json['weight'] ?? 0.0;
//     avatar = json['avatar'] ?? "";
//   }
// }
import 'dart:convert';
class MemberInfo {
  int memberId;
  String nickname;
  String sex;
  int height;
  double weight;
  // String birthday;
  String created;
  String avatar;
  int point;
  List<LabelVoList> labelVoList;

  MemberInfo.fromJson(Map<String, dynamic> json) {
    // birthday = json['birthday'] ?? "";
    created = json['created'] ?? "";
    height = json['height'] ?? 0;
    memberId = json['memberId'] ?? 0;
    nickname = json['nickname'] ?? "";
    sex = json['sex'] ?? "";
    weight = json['weight'] ?? 0.0;
    avatar = json['avatar'] ?? "";
    point = json['point'] ?? 0;
    List<dynamic> labelTemp = json['labelVoList'] ?? [];
    List<LabelVoList> labelData =
        labelTemp.map((item) => LabelVoList.fromJson(item)).toList() ?? [];
    labelVoList = labelData;
  }
}

class LabelVoList{
  int labelId;
  String labelname;
  String status;

  LabelVoList.fromJson(Map<String, dynamic> json) {
    labelname = json['labelname'] ?? "";
    status = json['status'] ?? "";
    labelId = json['labelId'] ?? 0;
  }

}