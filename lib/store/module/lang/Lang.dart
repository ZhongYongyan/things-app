import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Persistable.dart';
import 'package:app/base/util/StorageUtils.dart';
import 'package:app/generated/i18n.dart';

import '../../Store.dart';

class Localized {
  String _cn;
  String _en;

  Localized(String cn, String en) {
    _cn = cn;
    _en = en;
  }

  string(String lang) {
    if (lang == "cn") {
      return _cn;
    } else if(lang == "en"){
      return _en;
    } else {
      return "[null]";
    }
  }
}

class LangState extends Persistable with StorageMixin, LoggingMixin {
  String lang;

  localized(Localized value) {
    return value.string(lang);
  }

  @override
  void recoverSnapshot() {
    lang = storage.getString('lang.current');
  }

  @override
  void saveSnapshot() {
    storage.setString('lang.current', lang);
  }
}

class AuthActions with LoggingMixin {
  ActionHandler<StoreState> setup(String lang) {
    return (state) {
      state.lang.lang = lang;
      state.lang.saveSnapshot();
      return state;
    };
  }
}
