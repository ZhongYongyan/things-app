//  import 'package:quiver/core.dart';
//  bool operator ==(o) => o is Person && o.name == name && o.age == age;
//  int get hashCode => hash2(name.hashCode, age.hashCode);

class DeviceType {
  final String value;

  DeviceType(this.value);

  String toJson() => this.value;

  bool operator ==(o) => o is DeviceType && o.value == value;

  int get hashCode => value.hashCode;

  String get description {
    switch (value) {
      case 'AA':
        return '无线网关';
      case 'AB':
        return '微站网关';
      case 'B1':
        return '照明灯光';
      case 'B2':
        return '景观灯光';
      case 'B3':
        return '绿化灌溉';
      case 'C1':
        return '井盖监测';
      case 'C2':
        return '垃圾桶监测';
      case 'C3':
        return '消防栓监测';
      case 'C4':
        return '车位监测';
      case 'C5':
        return '防盗追踪';
      case 'F0':
        return '灯杆';
      case 'F1':
        return '广告屏';
      case 'F2':
        return '摄像机';
      case 'F3':
        return '广播';
      default:
        return 'undefind';
    }
  }

  factory DeviceType.fromJson(String value) => DeviceType(value);

  static final values = [
    AA,
    AB,
    B1,
    B2,
    B3,
    C1,
    C2,
    C3,
    C4,
    C5,
    F0,
    F1,
    F2,
    F3
  ];

  static final DeviceType None = DeviceType('');
  static final DeviceType AA = DeviceType('AA'); //'无线网关'
  static final DeviceType AB = DeviceType('AB'); //'微站网关'
  static final DeviceType B1 = DeviceType('B1'); //'照明灯光'
  static final DeviceType B2 = DeviceType('B2'); //'景观灯光'
  static final DeviceType B3 = DeviceType('B3'); //'绿化灌溉'
  static final DeviceType C1 = DeviceType('C1'); //'井盖监测'
  static final DeviceType C2 = DeviceType('C2'); //'垃圾桶监测'
  static final DeviceType C3 = DeviceType('C3'); //'消防栓监测'
  static final DeviceType C4 = DeviceType('C4'); //'车位监测'
  static final DeviceType C5 = DeviceType('C5'); //'防盗追踪'
  static final DeviceType F0 = DeviceType('F0'); //'灯杆'
  static final DeviceType F1 = DeviceType('F1'); //'广告屏'
  static final DeviceType F2 = DeviceType('F2'); //'摄像机'
  static final DeviceType F3 = DeviceType('F3'); //'广播'
}
