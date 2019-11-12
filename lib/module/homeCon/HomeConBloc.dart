import 'package:app/packages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class HomeConBloc extends BlocBase with LoggingMixin {
  HomeConBloc(BuildContext context, Store store) : super(context, store);
  void startup() {
    log.info("11111");
  }
}
