import 'package:app/base/entity/IwaAddress.dart';

typedef T ObjectDecodeHandler<T>(Map<String, dynamic> data);
class IwaMallDataFormat<T> {
  IwaMallDataFormat(this.errCode, this.errMsg);
  int errCode;
  T errMsg;
  IwaMallDataFormat.fromJson(Map<String, dynamic> json, [ObjectDecodeHandler<T> handler]) {
    errCode = json['errCode'] ?? 0;
    Map<String,dynamic> dataJson=json['errMsg'];
    if (dataJson != null && handler != null) {
      errMsg = handler(dataJson);
    }
  }
}