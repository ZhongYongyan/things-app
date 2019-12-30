import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:app/store/module/User.dart';
import 'package:quiver/strings.dart';

AuthActions authActions = AuthActions();

class AuthState extends Persistable with StorageMixin, LoggingMixin {
  String accessToken = "";
  bool frist = false;
  bool get isAuth {
    return isNotEmpty(accessToken);
  }
  bool get isFristShow {
    return  frist;
  }
  @override
  void recoverSnapshot() {
    accessToken = storage.getString('auth.accessToken');
  }

  @override
  void saveSnapshot() {
    storage.setString('auth.accessToken', accessToken);
    storage.setBool('auth.frist', frist);
  }
}

class AuthActions with LoggingMixin {

  ActionHandler<StoreState> login(String accessToken) {
    return (state) {
      state.auth.accessToken = accessToken;
      state.auth.frist = true;
      state.auth.saveSnapshot();
      return state;
    };
  }

  ActionHandler<StoreState> logout() {
    return (state) {
      state.auth = AuthState()..saveSnapshot();
      state.user = UserState();
      return state;
    };
  }
}
