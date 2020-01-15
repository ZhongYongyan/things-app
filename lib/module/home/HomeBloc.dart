import 'package:app/base/api/AffiliateApis.dart';
import 'package:app/packages.dart';
import 'package:app/store/module/Auth.dart';
import 'package:app/util/Page.dart';
import 'package:app/util/Result.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class HomeBloc extends BlocBase with LoggingMixin {
  HomeBloc(BuildContext context, Store store) : super(context, store);
  bool show = false;
  String get name => state.auth.name;
  void startup() {
    if (name == "--") {
      getUser();
    }
  }

  void to() {
    navigate.pushNamed('/user');
  }

  void add() {
    navigate.pushNamed('/management');

  }

  void getUser() async {
    Result<Page> response = await AffiliateApis.getAffiliate(1, 10, "ASC");
    bool code = response.success;
    var list = response.data.items;
    if (list.length>0) {
      dispatch(authActions.user(list[0].nickname));
    }
  }
}
