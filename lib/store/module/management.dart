import 'package:app/base/entity/DeviceModelAll.dart';
import 'package:app/base/entity/MemberNews.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Persistable.dart';
import 'package:app/base/util/StorageUtils.dart';

ManagementActions managementActions = ManagementActions();

class ManagementState extends Persistable with StorageMixin, LoggingMixin {
  var loading = 'loadingTag';
  static var loadingTag =
  DeviceModelAll.fromJson({'sortName': 'loadingTag', 'model': []});
  var words = <DeviceModelAll>[loadingTag];
  int id = 0;
  var lists = [];
  var indexPage = 1;
  var index = 0;
  bool indexshow = true;
  var text = "按摩椅";
  bool loadShow = false;
  @override
  void recoverSnapshot() {

  }

  @override
  void saveSnapshot() {
    words =  <DeviceModelAll>[loadingTag];
    id = 0;
    lists = [];
    indexPage = 1;
    index = 0;
    indexshow = true;
    text = "按摩椅";
    loadShow = false;
  }

}

class ManagementActions with LoggingMixin {

}
