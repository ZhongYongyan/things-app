import 'package:logging/logging.dart';

import 'Message.dart';

class BlueProtocol {
  Logger _log = Logger('BlueProtocol');
  Map<int, List<int>> _dataList;
  List<Message> _msgList = List();
  List<int> createProtocolCommand(Message msg) {
    List<int> bytes = List();
    switch (msg.command) {
      case 'getWiFiStatus':
        bytes = [0xaa, 0xff, 0x04, 0x01, 0x01, 0x01, 0x01, 0x51, 0x0d, 0x0a];
        _msgList.add(msg);
        break;
      case 'getDeviceSn':
        bytes = [0xaa, 0xff, 0x05, 0x01, 0x01, 0x01, 0x01, 0x50, 0x0d, 0x0a];
        _msgList.add(msg);
        break;
      case 'getSequence':
        bytes = [0xaa, 0xff, 0x06, 0x01, 0x01, 0x01, 0x01, 0x53, 0x0d, 0x0a];
        _msgList.add(msg);
        break;
      default :
        bytes = null;
        break;
    }
    return bytes;
  }

  Message listen(List<int> data) {
    if (data.length < 8 || isCheckError(data)) {
      _log.info('数据异常');
    }
    if(_msgList.isNotEmpty) {
      if (data[5] > 0x00) {
        if (_dataList == null){
          _dataList = Map();
        }
        _dataList[data[4]] = data.sublist(6, data[5] + 6);
      }
      if(data[3] == data[4] || data[3] == _dataList.length) {
        List<int> res = List();
        for (int i = 1 ; i <= _dataList.length; i++) {
          res.addAll(_dataList[i]);
        }
        _dataList = null;
        switch (data[2]) {
          case 0x52:
            Message message = _msgList[0].success(getDeviceInfo(res).toUpperCase());
            _msgList.removeAt(0);
            return message;
          case 0x53:
            Message message = _msgList[0].success(getDeviceInfo(res).toUpperCase());
            _msgList.removeAt(0);
            return message;
          case 0x54:
            Map<String, dynamic> result = Map();
            result['status'] = res[0];
            result['ip'] = '${res[1]}.${res[2]}.${res[3]}.${res[4]}';
            Message message = _msgList[0].success(result);
            _msgList.removeAt(0);
            return message;
        }
      }
    }
    return null;
  }

  String getDeviceInfo(List<int> data) {
    String info = '';
    for(int d in data) {
      if (d == 0x00) {
        break;
      }else{
        String num = d.toRadixString(16);
        if (num.length == 1) {
          num = '0${num}';
        }
        info = info == '' ? '${num}':'${info}${num}';
      }
    }
    return info;
  }

  bool isCheckError (List<int> data) {
    int check_num = 0x00;
    for(int i = 0; i < data.length - 3; i++) {
      check_num ^= data[i];
    }
    return check_num == data[data.length - 3] ? false : true;
  }
}



