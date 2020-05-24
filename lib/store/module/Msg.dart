import 'package:app/base/entity/MemberNews.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Persistable.dart';
import 'package:app/base/util/StorageUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/store/module/User.dart';
import 'package:quiver/strings.dart';

MsgActions msgActions = MsgActions();

class MsgState extends Persistable with StorageMixin, LoggingMixin {
  var loading = 'loadingTag';
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
  ActionHandler<StoreState> saveUser(list) {
    return (state) {
      state.msg.words = list;
      return state;
    };
  }
  ActionHandler<StoreState> saveShow(start) {
    return (state) {
      state.msg.indexshow = start;
      return state;
    };
  }
  ActionHandler<StoreState> saveIndex(index) {
    return (state) {
      state.msg.indexPage = index;
      return state;
    };
  }
}
