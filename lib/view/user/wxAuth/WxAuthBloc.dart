import 'dart:convert';

import 'package:app/base/api/MemberApis.dart';
import 'package:app/base/entity/AccessToken.dart';
import 'package:app/base/entity/Member.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/Store.dart';
import 'package:app/base/api/AdminApis.dart';
import 'package:app/store/module/Auth.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart';
class WxAuthBloc extends BlocBase with LoggingMixin{
  WxAuthBloc(BuildContext context, Store store) : super(context, store);

  void startup() async {
  }

  void auth(){
    navigate.pushNamed("/bindPhone");
  }
}