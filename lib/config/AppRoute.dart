import 'package:app/module/launch/LaunchPage.dart';
import 'package:app/module/user/login/LoginPage.dart';
import 'package:app/module/homeCon/HomeConPage.dart';
import 'package:app/module/home/HomePage.dart';
import 'package:app/module/guide/GuidePage.dart';
import 'package:app/packages.dart';
import 'package:flutter/material.dart';

Route appRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/login':
      return _build(settings, LoginPage(), TransactionType.fromRight);
//    case '/register':
//      return _build(settings, RegisterPage(), TransactionType.fromRight);
    case '/launch':
      return _build(settings, LaunchPage(), TransactionType.fadeIn);
    case '/homeCon':
      return _build(settings, HomeConPage(), TransactionType.fadeIn);
    case '/home':
      return _build(settings, HomePage(), TransactionType.fadeIn);
    case '/guide':
      return _build(settings, GuidePage(), TransactionType.fadeIn);

    default:
      return _build(settings, LaunchPage(), TransactionType.fadeIn);
  }
}

PageRouteBuilder _build(
  RouteSettings settings,
  Widget builder,
  TransactionType transactionType,
) {
//  return new MaterialPageRoute(
//    settings: settings,
//    builder: (BuildContext context) => builder,
//  );

//  return PageRouteBuilder(
//    pageBuilder: (context, anim1, anim2) => builder,
//    transitionsBuilder: (context, anim1, anim2, child) => FadeTransition(opacity: anim1, child: child),
//    transitionDuration: Duration(seconds: 1),
//  );

  var navigateTransaction = NavigateTransaction(
      transactionType: transactionType,
      pageBuilder: (BuildContext context, arg) {
        return builder;
      });

  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, anim1, anim2) => builder,
    transitionsBuilder: navigateTransaction.build(transactionType),
  );
}
