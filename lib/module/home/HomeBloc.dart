import 'package:app/packages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class HomeBloc extends BlocBase with LoggingMixin {
  HomeBloc(BuildContext context, Store store) : super(context, store);

  bool show = false;

  void startup() {
    log.info("w222222222222222");
  }

  void to() {
    navigate.pushNamed('/user');
  }

  void add() {
    navigate.pushNamed('/management');

  }
}
