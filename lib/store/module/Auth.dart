import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Persistable.dart';
import 'package:app/base/util/StorageUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/store/module/%20Information.dart';
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

  String get name {
    userName = storage.getString('auth.userName');
    return userName;
  }

  String get url {
    userUrl = storage.getString('auth.userUrl');
    return userUrl;
  }

  int get userId {
    id = storage.getInt('auth.userAffiliateId');
    return id;
  }

  @override
  void recoverSnapshot() {
    accessToken = storage.getString('auth.accessToken');
    id = storage.getInt('auth.id');
  }

  @override
  void saveSnapshot() {
    storage.setString('auth.accessToken', accessToken);
    storage.setInt('auth.id', id);
  }

  @override
  void saveUser() {
    storage.setString('auth.userName', userName);
    storage.setString('auth.userUrl', userUrl);
    storage.setInt('auth.userAffiliateId', affiliateId);
  }

  @override
  void recoverUser() {
    userName = storage.getString('auth.userName');
    userUrl = storage.getString('auth.userUrl');
    affiliateId = storage.getInt('auth.userAffiliateId');
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

  ActionHandler<StoreState> user(String name,String url,int affiliateId) {
    return (state) {
      state.auth.userName = name;
      state.auth.userUrl = url;
      state.auth.affiliateId = affiliateId;
      state.auth.saveUser();
      return state;
    };
  }


  ActionHandler<StoreState> logout() {
    return (state) {
      state.auth = AuthState()..saveSnapshot();
      state.auth = AuthState()..saveUser();
      state.msg = MsgState()..saveSnapshot();
      state.information = InformationState()..saveSnapshot();
      state.management = ManagementState()..saveSnapshot();
      state.member = MemberState()..saveSnapshot();
      state.user = UserState();
      return state;
    };
  }
}
