import 'package:app/base/util/NavigateTransaction.dart';
import 'package:app/view/config/WifiConfigPage.dart';
import 'package:app/view/guide/GuidePage.dart';
import 'package:app/view/home/HomePage.dart';
import 'package:app/view/home/management/ManagementPage.dart';
import 'package:app/view/home/user/UserPage.dart';
import 'package:app/view/home/user/details/DatailsPage.dart';
import 'package:app/view/home/user/main/MainPage.dart';
import 'package:app/view/information/details/DetailsPage.dart';
import 'package:app/view/launch/LaunchPage.dart';
import 'package:app/view/mall/MallPage.dart';
import 'package:app/view/mall/iwaMall/addressEdit/addressEditPage.dart';
import 'package:app/view/mall/iwaMall/addressList/AddressListPage.dart';
import 'package:app/view/mall/iwaMall/confirmTheOrder/ConfirmTheOrderPage.dart';
import 'package:app/view/mall/iwaMall/goodsDetail/GoodsDetailPage.dart';
import 'package:app/view/mall/iwaMall/orderDetail/OrderDetailPage.dart';
import 'package:app/view/mall/iwaMall/orders/OrderPage.dart';
import 'package:app/view/mall/iwaMall/successfulPayment/SuccessfulPaymentPage.dart';
import 'package:app/view/msg/MsgPage.dart';
import 'package:app/view/msg/details/DetailsPage.dart';
import 'package:app/view/my/MyPage.dart';
import 'package:app/view/my/details/DetailsPage.dart';
import 'package:app/view/my/details/labels/LabelsPage.dart';
import 'package:app/view/my/healthArchive/HealthArchivePage.dart';
import 'package:app/view/my/healthArchive/createFamily/CreateFamilyPage.dart';
import 'package:app/view/my/healthArchive/healthData/HealthDataPage.dart';
import 'package:app/view/my/healthArchive/homeManagement/HomeManagementPage.dart';
import 'package:app/view/my/healthArchive/inviteFamily/InviteFamilyPage.dart';
import 'package:app/view/my/memberBenefits/MemberRightsPage.dart';
import 'package:app/view/page/PagePage.dart';
import 'package:app/view/plugin/PluginPage.dart';
import 'package:app/view/signIn/SignInPage.dart';
import 'package:app/view/user/bindPhone/BindPhonePage.dart';
import 'package:app/view/user/login/LoginPage.dart';
import 'package:app/view/user/wxAuth/WxAuthPage.dart';
import 'package:flutter/material.dart';

Route appRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/login':
      return _build(settings, LoginPage(), TransactionType.fromRight);
//    case '/register':
//      return _build(settings, RegisterPage(), TransactionType.fromRight);
    case '/launch':
      return _build(settings, LaunchPage(), TransactionType.fadeIn);
    case '/page':
      return _build(settings, PagePage(), TransactionType.fadeIn);
    case '/home':
      return _build(settings, HomePage(), TransactionType.fadeIn);
    case '/guide':
      return _build(settings, GuidePage(), TransactionType.fadeIn);
    case '/details':
      return _build(settings, DetailsPage(), TransactionType.fromRight);
    case '/user':
      return _build(settings, UserPage(), TransactionType.fromRight);
    case '/userMainPage':
      return _build(settings, MainPage(), TransactionType.fromRight);
    case '/userDetails':
      return _build(settings, UserDatailsPage(), TransactionType.fromRight);
    case '/msgDetails':
      return _build(settings, MsgDetailsPage(), TransactionType.fromRight);
    case '/management':
      return _build(settings, ManagementPage(), TransactionType.fromRight);
    case '/plugin':
      return _build(settings, PluginPage(), TransactionType.fromRight);
    case '/wifi-connfig':
      return _build(settings, WifiConfigPage(), TransactionType.fromRight);
    case '/msg':
      return _build(settings,MsgPage(),TransactionType.fromRight);
    case '/myDetails':
      return _build(settings, MyDetailsPage(), TransactionType.fromRight);
    case '/bindPhone':
      return _build(settings, BindPhonePage(), TransactionType.fromRight);
    case '/wxAuth':
      return _build(settings, WxAuthPage(), TransactionType.fromRight);
    case '/signIn':
      return _build(settings, SignInPage(), TransactionType.fromRight);
    case '/labels':
      return _build(settings, LabelsPage(), TransactionType.fromRight);
    case '/memberRights':
      return _build(settings, MemberRightsPage(), TransactionType.fromRight);
    case '/mall':
      return _build(settings,MallPage(),TransactionType.fromRight);
    case '/goodsDetail':
      return _build(settings,GoodsDetailPage(),TransactionType.fromRight);
    case '/confirmTheOrder':
      return _build(settings,ConfirmTheOrderPage(),TransactionType.fromRight);
    case '/addressList':
      return _build(settings,AddressListPage(),TransactionType.fromRight);
    case '/addressEdit':
      return _build(settings,AddressEditPage(),TransactionType.fromRight);
    case '/orders':
      return _build(settings,OrderPage(),TransactionType.fromRight);
    case '/orderDetail':
      return _build(settings,OrderDetailPage(),TransactionType.fromRight);
    case '/successfulPayment':
      return _build(settings,SuccessfulPaymentPage(),TransactionType.fromRight);
    case '/healthArchive':
      return _build(settings,HealthArchivePage(),TransactionType.fromRight);
    case '/createFamily':
      return _build(settings,CreateFamilyPage(),TransactionType.fromRight);
    case '/homeManagement':
      return _build(settings,HomeManagementPage(),TransactionType.fromRight);
    case '/inviteFamily':
      return _build(settings,InviteFamilyPage(),TransactionType.fromRight);
    case '/healthData':
      return _build(settings,HealthDataPage(),TransactionType.fromRight);
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
