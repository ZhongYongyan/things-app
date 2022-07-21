import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
class HealthDataBloc extends BlocBase with LoggingMixin {
  HealthDataBloc(BuildContext context, Store store)
      : super(context, store);
  String get title => state.lang.localized(Langs.healthDetail);
  var user;
  String pageTitle;

  void setup(){
    print('sdfsfsdf');
    pageTitle=user['name']+title;
  }
}