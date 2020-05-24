import 'package:app/base/entity/Info.dart';
import 'package:app/base/entity/MemberNews.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Persistable.dart';
import 'package:app/base/util/StorageUtils.dart';

InformationActions msgActions = InformationActions();

class InformationState extends Persistable with StorageMixin, LoggingMixin {
  var loading = 'loadingTag';
  static var loadingTag = Info.fromJson({'title': 'loadingTag'});
  var words = <Info>[loadingTag];
  var textList = [];
  int sortId = 0;
  var lists = [];
  var indexPage = 1;
  bool indexshow = true;
  @override
  void recoverSnapshot() {

  }

  @override
  void saveSnapshot() {

  }

}

class InformationActions with LoggingMixin {

}
