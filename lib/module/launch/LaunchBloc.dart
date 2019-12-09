import 'package:app/packages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class LaunchBloc extends BlocBase with LoggingMixin {
  LaunchBloc(BuildContext context, Store store) : super(context, store);

  bool get actionsVisible => !state.auth.isAuth;

  void startup() {
    Future.delayed(Duration(seconds: 2), () {
      if(!actionsVisible) {
        navigate.pushReplacementNamed('/page');
      }else{
        navigate.pushReplacementNamed('/guide');
      }
    });
  }

  void loginHandler() {
    log.info("wwww");
    navigate.pushReplacementNamed('/guide');
  }

  void registerHandler() {
    navigate.pushNamed('/register');
  }
}
