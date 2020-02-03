import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Persistable.dart';
import 'package:app/base/util/StorageUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/store/module/User.dart';
import 'package:quiver/strings.dart';

AuthActions authActions = AuthActions();

class AuthState extends Persistable with StorageMixin, LoggingMixin {
  String accessToken = "";
  String userName = "--";

  bool get isAuth {
    return isNotEmpty(accessToken);
  }

  String get name {
    return userName;
  }

  @override
  void recoverSnapshot() {
    accessToken = storage.getString('auth.accessToken');
  }

  @override
  void saveSnapshot() {
    storage.setString('auth.accessToken', accessToken);
  }

  @override
  void saveUser() {
    storage.setString('auth.userName', userName);
  }

  @override
  void recoverUser() {
    userName = storage.getString('auth.userName');
  }
}

class AuthActions with LoggingMixin {
  ActionHandler<StoreState> login(String accessToken) {
    return (state) {
      state.auth.accessToken = accessToken;
      state.auth.saveSnapshot();
      return state;
    };
  }

  ActionHandler<StoreState> user(String name) {
    return (state) {
      state.auth.userName = name;
      state.auth.saveUser();
      return state;
    };
  }

  ActionHandler<StoreState> logout() {
    return (state) {
      state.auth = AuthState()..saveSnapshot();
      state.auth = AuthState()..saveUser();
      state.user = UserState();
      return state;
    };
  }
}
