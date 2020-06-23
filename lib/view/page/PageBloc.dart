import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class PageBloc extends BlocBase with LoggingMixin {
  PageBloc(BuildContext context, Store store) : super(context, store);

  void startup() {}
}
