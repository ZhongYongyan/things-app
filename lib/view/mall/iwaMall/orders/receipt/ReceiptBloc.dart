import 'dart:io';
import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/entity/IwaMall.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class ReceiptBloc extends BlocBase with LoggingMixin {
  ReceiptBloc(BuildContext context, Store store) : super(context, store);
  String get confirmReceipt => state.lang.localized(Langs.confirmReceipt);
  bool loading=false;
}