import 'package:app/base/entity/Affiliate.dart';
import 'package:app/base/entity/Member.dart';
import 'package:app/base/entity/MemberNews.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Persistable.dart';
import 'package:app/base/util/StorageUtils.dart';

import '../Store.dart';

MemberActions memberActions = MemberActions();

class MemberState extends Persistable with StorageMixin, LoggingMixin {
  var loading = 'loadingTag';
  static var loadingTag = Affiliate.fromJson({'nickname': 'loadingTag'});
  var words = <Affiliate>[loadingTag];
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
    words =   <Affiliate>[loadingTag];
    indexPage = 1;
    indexshow = true;
  }

}

class MemberActions with LoggingMixin {

}
