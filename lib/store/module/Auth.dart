import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Persistable.dart';
import 'package:app/base/util/StorageUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/store/module/User.dart';
import 'package:quiver/strings.dart';

AuthActions authActions = AuthActions();

class AuthState extends Persistable with StorageMixin, LoggingMixin {
  String accessToken = "";
  String userName = "访客";
  String userUrl = "";
  bool get isAuth {
    return isNotEmpty(accessToken);
  }

  String get name {
    return userName;
  }

  String get url {
    return userUrl;
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

  @override
  void saveUrl() {
    storage.setString('auth.userUrl', userUrl);
  }

  @override
  void recoverUrl() {
    userUrl = storage.getString('auth.userUrl');
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
  ActionHandler<StoreState> url(String url) {
    return (state) {
      state.auth.userUrl = url;
      state.auth.saveUrl();
      return state;
    };
  }

  ActionHandler<StoreState> logout() {
    return (state) {
      state.auth = AuthState()..saveSnapshot();
      state.auth = AuthState()..saveUser();
      state.auth = AuthState()..saveUrl();
      state.user = UserState();
      return state;
    };
  }
}
