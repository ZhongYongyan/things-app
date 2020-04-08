import 'package:app/base/api/AffiliateApis.dart';
import 'package:app/base/plugin/PluginManager.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Page.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/Auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';

class HomeBloc extends BlocBase with LoggingMixin {
  HomeBloc(BuildContext context, Store store) : super(context, store);
  bool show = false;

  String get name => state.auth.name != null ? state.auth.name : '访客';

  void startup() {
    if (name == "访客") {
      getUser();
    }
  }

  void to() {
    navigate.pushNamed('/user');
  }

  void add() {
    navigate.pushNamed('/management');
  }

  void toPlugin() {
    navigate.pushNamed('/plugin', arguments: {"url": ""});
  }

  void getUser() async {
    Result<Page> response = await AffiliateApis.getAffiliate(1, 10, "ASC");
    bool code = response.success;
    var list = response.data.items;
    if (list.length > 0) {
      dispatch(authActions.user(list[0].nickname));
    }
  }
}
