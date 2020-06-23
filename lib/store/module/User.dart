import 'package:app/base/api/AccountApis.dart';
import 'package:app/base/entity/Account.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/StorageUtils.dart';
import 'package:app/store/Store.dart';

UserActions userActions = UserActions();

class UserState with StorageMixin, LoggingMixin {
  int id = 0;
  String name = '';
  String phone = '';
  String password = '';
  int created = 0;
  int createUser = 0;
  int updated = 0;
  List<int> roles = List<int>();
  String workNumber = '';
  String avatar = '';
}

class UserActions with LoggingMixin {
  ActionHandler<StoreState> merge(Account data) {
    return (state) {
      state.user = UserState()
        ..id = data.id ?? data.id
        ..name = data.name ?? data.name
        ..phone = data.phone ?? data.phone
        ..password = data.password ?? data.password
        ..created = data.created ?? data.created
        ..createUser = data.createUser ?? data.createUser
        ..updated = data.updated ?? data.updated
        ..roles = data.roles ?? data.roles
        ..workNumber = data.workNumber ?? data.workNumber
        ..avatar = data.avatar ?? data.avatar;
      return state;
    };
  }

  ActionAsyncHandler<StoreState> loadInfo() {
    return (state, dispatch) async {
      var identity = await AccountApis.getIdentity();
      var result = await AccountApis.getAccount(int.parse(identity.data.id));
      if (result.success) {
        dispatch(merge(result.data));
      } else {
        log.warning('getAccount response error: $result');
      }
    };
  }
}
