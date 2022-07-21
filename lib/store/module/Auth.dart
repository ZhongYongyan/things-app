import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Persistable.dart';
import 'package:app/base/util/StorageUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/store/module/Information.dart';
import 'package:app/store/module/User.dart';
import 'package:quiver/strings.dart';

import 'Member.dart';
import 'Msg.dart';
import 'Management.dart';

AuthActions authActions = AuthActions();

class AuthState extends Persistable with StorageMixin, LoggingMixin {
  int id=0;
  String accessToken = "";
  String userName = "访客";
  String userUrl = "";
  int affiliateId = 0;

  bool get isAuth {
    return isNotEmpty(accessToken);
  }

  @override
  void recoverSnapshot() {
    accessToken = storage.getString('auth.accessToken');
    id = storage.getInt('auth.id');

    userName = storage.getString('auth.userName');
    userUrl = storage.getString('auth.userUrl');
    affiliateId = storage.getInt('auth.affiliateId');
  }

  @override
  void saveSnapshot() {
    storage.setString('auth.accessToken', accessToken);
    storage.setInt('auth.id', id);


    storage.setString('auth.userName', userName);
    storage.setString('auth.userUrl', userUrl);
    storage.setInt('auth.affiliateId', affiliateId);
  }


}

class AuthActions with LoggingMixin {
  ActionHandler<StoreState> login(int id,String accessToken) {
    return (state) {
      state.auth.id = id;
      state.auth.accessToken = accessToken;
      state.auth.saveSnapshot();
      return state;
    };
  }

  ActionHandler<StoreState> logout() {
    return (state) {
      state.auth = AuthState()..saveSnapshot();
      state.msg = MsgState()..saveSnapshot();
      state.information = InformationState()..saveSnapshot();
      state.management = ManagementState()..saveSnapshot();
      state.member = MemberState()..saveSnapshot();
      state.user = UserState();
      return state;
    };
  }

  ActionHandler<StoreState> select(int id, String nickname, String avatar) {
    return (state) {
      state.auth.affiliateId = id;
      state.auth.userName = nickname;
      state.auth.userUrl = avatar;
      state.auth.saveSnapshot();
      return state;
    };
  }
}
