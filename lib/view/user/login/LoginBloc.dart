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

class LoginBloc extends BlocBase with LoggingMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode usernameFocus = FocusNode();//获取焦点
  final FocusNode passwordFocus = FocusNode();

  final TextEditingController usernameController =
      TextEditingController(text: '');//监听用户账号输入
  final TextEditingController passwordController =
      TextEditingController(text: '');//监听用户密码输入

  Animation<double> headerAnimation;
  AnimationController headerController;
  String get phoneNumber => state.lang.localized(Langs.phoneNumber);
  String get code => state.lang.localized(Langs.code);
  String get getCode => state.lang.localized(Langs.getCode);
  String get login => state.lang.localized(Langs.login);
  String get resetCode => state.lang.localized(Langs.resetCode);
  String get errorPhoneNumber => state.lang.localized(Langs.errorPhoneNumber);
  String get codeSuccess => state.lang.localized(Langs.codeSuccess);
  Timer _timer;
  int durationTime = 1500; //错误弹框时间
  // 登录处理中
  bool loginProcessing = false;
  bool phoneisEmpty = false;
  bool codeisEmpty = false;
  int countdownTime = 0;
  bool countdownTimeShow = false;
  bool againLoginShow = true;
  bool registerSuccess=false;
  String validCode = "";

  LoginBloc(
    BuildContext context,
    Store<StoreState> store,
    TickerProvider tickerProvider,
  ) : super(context, store) {
    if (!againLoginShow) {
      setModel(() {
        usernameController.text = "17628045052";
      });
    }
    headerController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: tickerProvider,
    )..repeat(min:0,max:0);
    headerAnimation = CurvedAnimation(
      parent: headerController,
      curve: Curves.easeOut,
    );
    headerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 结束时继续播放，实现无限循环
        headerController.reset();
        headerController.forward();
      }
    });
    usernameFocus.addListener(() {
      if (usernameFocus.hasFocus && headerController.isDismissed) {
        setModel(() {
          headerController.forward();
        });
      }
    });
    passwordFocus.addListener(() {
      if (passwordFocus.hasFocus && headerController.isDismissed) {
        setModel(() {
          headerController.forward();
        });
      }
    });
  }

  FutureOr Function(Result<AccessToken> value) get onValue => null;

  @override
  void dispose() {
    usernameFocus.dispose();
    passwordFocus.dispose();

    usernameController.dispose();
    passwordController.dispose();

    headerController.dispose();
    super.dispose();
  }

  void backHandler() {

    navigate.pop();
  }

  void loginHandler() async {
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

    setModel(() {
      loginProcessing = true;
    });
    if (phoneisEmpty || codeisEmpty) {
      setModel(() {
        loginProcessing = false;
      });
      String msg=phoneisEmpty?phoneNumber:code;
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          textColor: Colors.white,
          backgroundColor: Colors.black,
      );
      return;
    }
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool matched = exp.hasMatch(usernameController.text);
    print(usernameController);
    if (!matched) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF0079FE),
          duration: Duration(milliseconds: durationTime),
          content: SizedBox(
            width: double.infinity,
            height: 40,
            child: Center(
              child: Text(errorPhoneNumber),
            ),
          ),
        ),
      );
      setModel(() {
        loginProcessing = false;
      });
      return;
    }
    // FocusScope.of(context).requestFocus(FocusNode());
    Result<AccessToken> response = await AdminApis.postAccessToken(
        usernameController.text, validCode, passwordController.text);
    print(response);
    bool res = response.success;
    // dispatch(authActions.login(0, response.data.accessToken));
    // Result<Member> memberResponse = await MemberApis.getMember();
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
      // scaffoldKey.currentState.showSnackBar(
      //   SnackBar(
      //     duration: Duration(milliseconds: durationTime),
      //     backgroundColor: Color(0xFF0079FE),
      //     content: SizedBox(
      //       width: double.infinity,
      //       height: 40,
      //       child: Center(
      //         child: Text('登录成功'),
      //       ),
      //     ),
      //   ),
      // );
      dispatch(authActions.login(0, response.data.accessToken));
      Result<Member> memberResponse = await MemberApis.getMember();
      dispatch(authActions.login(memberResponse.data.id, response.data.accessToken));

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
      String message = response.message;
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        backgroundColor: Colors.black,
      );
    }

    setModel(() {
      loginProcessing = false;
    });
  }

  void registerHandler() {
    navigate.pushReplacementNamed('/register');
  }

  void forgetPasswordHandler() {}

  void againlog() {
    setModel(() {
      againLoginShow = true;
      usernameController.text = "";
      codeisEmpty = false;
      countdownTimeShow = false;
    });
  }

  Future<void> startCountdown() async {
    if (usernameController.text == "") {
      setModel(() {
        phoneisEmpty = true;
      });
      return;
    }
    if (countdownTimeShow) {
      return;
    }
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool matched = exp.hasMatch(usernameController.text);
    if (!matched) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF0079FE),
          duration: Duration(milliseconds: durationTime),
          content: SizedBox(
            width: double.infinity,
            height: 40,
            child: Center(
              child: Text(errorPhoneNumber),
            ),
          ),
        ),
      );
      return;
    }
    Fluttertoast.showToast(
        msg: codeSuccess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        textColor: Colors.white,
        backgroundColor: Colors.black,
        fontSize: 16.0);
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
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
    var timestamp = new DateTime.now().millisecondsSinceEpoch;
    var str = usernameController.text +
        timestamp.toString() +
        "eSloN66D8D2XSVQyruIhrJGU5ELfyEJU";
    var encoding = md5.convert(utf8.encode(str)).toString();
    String response =
        await AdminApis.getCode(encoding, usernameController.text, timestamp);
    if (response != "err") {
      validCode = response;
    }
  }

  //微信登录
  void wxLogin() async {
    navigate.pushNamed("/wxAuth");
  }

  //用户点击确认进入首页
  void ensureRegister(){
    setModel(() {
      registerSuccess = false;
    });
    Future.delayed(Duration.zero,(){
      navigate.pushNamedAndRemoveUntil('/page', (route) {
        return route.settings.name == '/page';
      });
    });

  }
}
