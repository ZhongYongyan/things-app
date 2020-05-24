import 'package:app/base/entity/MemberNews.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Persistable.dart';
import 'package:app/base/util/StorageUtils.dart';

MsgActions msgActions = MsgActions();

class MsgState extends Persistable with StorageMixin, LoggingMixin {
  static var loadingTag = MemberNews.fromJson({'title': 'loadingTag'});
  var words = <MemberNews>[loadingTag];
  var indexPage = 1;
  bool indexshow = true;
  @override
  void recoverSnapshot() {

  }

  @override
  void saveSnapshot() {

  }

}

class MsgActions with LoggingMixin {

}
