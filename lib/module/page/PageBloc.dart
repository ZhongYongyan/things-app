import 'package:app/packages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class PageBloc extends BlocBase with LoggingMixin {
  PageBloc(BuildContext context, Store store) : super(context, store);
  void startup() {
    log.info("11111");
  }
}
