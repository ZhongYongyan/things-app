import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app/base/api/AdminApis.dart';
import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/entity/AccessToken.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
class InviteFamilyBloc extends BlocBase with LoggingMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController=TextEditingController(text: '');//监听用户手机号输入
  final TextEditingController codeController =TextEditingController(text: '');//监听用户验证码输入
  InviteFamilyBloc(BuildContext context, Store store,TickerProvider tickerProvider) : super(context, store);

  String get title => state.lang.localized(Langs.register);
  String get inviteMemberJoin => state.lang.localized(Langs.inviteMemberJoin);
  String get phoneNumber => state.lang.localized(Langs.phoneNumber);
  String get code => state.lang.localized(Langs.code);
  String get getCode => state.lang.localized(Langs.getCode);
  String get resetCode => state.lang.localized(Langs.resetCode);
  String get errorPhoneNumber => state.lang.localized(Langs.errorPhoneNumber);
  String get codeSuccess => state.lang.localized(Langs.codeSuccess);
  String get invite => state.lang.localized(Langs.invite);
  String get errCode => state.lang.localized(Langs.errCode);
  String get homeSuffix => state.lang.localized(Langs.homeSuffix);
  String get inviteFail => state.lang.localized(Langs.inviteFail);
  String get inviteSuccess => state.lang.localized(Langs.inviteSuccess);
  String master='谢安国';
  bool loginProcessing =false;
  bool countdownTimeShow=false;
  bool phoneIsEmpty = false;
  bool codeIsEmpty = false;
  Timer _timer;
  String validCode = "";
  String memberPhone='';
  int countdownTime = 0;//倒计时
  RegExp exp = RegExp(r'^(1[3-9])\d{9}$');//手机号正则
  final FocusNode phoneFocus = FocusNode();//获取焦点
  final FocusNode codeFocus = FocusNode();


  //获取验证码
  Future<void> startCountdown() async {
    if (phoneController.text == "") {//未输入手机号
      showToast(phoneNumber);
      return;
    }
    if (countdownTimeShow) {
      return;
    }
    bool matched = exp.hasMatch(phoneController.text);
    if (!matched) {
      showToast(errorPhoneNumber);
      return;
    }
    showToast(codeSuccess);
    countdownTime = 60;
    setModel(() {
      countdownTimeShow = true;
    });
    final call = (timer) {
      setModel(() {
        if (countdownTime < 2) {
          _timer.cancel();
          countdownTimeShow = false;
        } else {
          countdownTime -= 1;
        }
      });
    };//倒计时
    _timer = Timer.periodic(Duration(seconds: 1), call);
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var str = phoneController.text +
        timestamp.toString() +
        "eSloN66D8D2XSVQyruIhrJGU5ELfyEJU";
    var encoding = md5.convert(utf8.encode(str)).toString();
    String response = await AdminApis.getCode(encoding, phoneController.text, timestamp);
    print(response);
    if (response != "err") {
      validCode = response;
    }
  }

  //注册
  void inviteHandler() async {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     backgroundColor: Colors.black,
    //     //   elevation: 0,
    //       behavior: SnackBarBehavior.floating,
    //       duration: Duration(seconds: 2),
    //     width: 120.0,
    //     //   margin: EdgeInsets.fromLTRB(120,200,120,400),
    //     content: Align(
    //       alignment: FractionalOffset(0.5,0.5),
    //       heightFactor: 1,
    //       child: Container(
    //         height: 65,
    //         child: Column(
    //           children: [
    //             Icon(Icons.check_circle_outline,color: Colors.white,size: 40,),
    //             Text('登录成功',style: TextStyle(fontSize: 16),)
    //           ],
    //         ),
    //       ),
    //     )
    //   ),
    // );
    if(loginProcessing) return;
    if (!formKey.currentState.validate()) return;

    if (phoneIsEmpty || codeIsEmpty) {
      String msg=phoneIsEmpty?phoneNumber:code;
      showToast(msg);
      return;
    }

    bool matched = exp.hasMatch(phoneController.text);
    if (!matched) {
      showToast(errorPhoneNumber);
      return;
    }
    setModel(() {
      loginProcessing = true;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    Result<AccessToken> response = await AdminApis.postAccessToken(phoneController.text, validCode, codeController.text);
    print(response);
    bool res = response.success;
    // setModel(() {
    //   if(_timer != null) {
    //     _timer.cancel();
    //   }
    //   countdownTimeShow = false;
    //   registerSuccess = true;
    // });
    // headerController.forward();
    // bool code=true;
    if (res) {
      setModel(() {
        if(_timer != null) {
          _timer.cancel();
        }
        countdownTimeShow = false;
        // registerSuccess = true;
      });
      // headerController.forward();
      navigate.pushNamedAndRemoveUntil('/page', (route) {
        return route.settings.name == '/page';
      });
    } else {
      showToast(response.message);
    }
    setModel(() {
      loginProcessing = false;
    });
  }

  @override
  void dispose() {
    phoneFocus.dispose();
    codeFocus.dispose();
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }
}