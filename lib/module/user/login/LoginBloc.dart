import 'dart:ui';

import 'package:app/base/entity/AccessToken.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:app/store/module/Auth.dart';
import 'package:app/util/Result.dart';
import 'package:dio/dio.dart';
import 'package:app/base/api/AdminApis.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'dart:async';

class LoginBloc extends BlocBase with LoggingMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  final TextEditingController usernameController =
      TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  Animation<double> headerAnimation;
  AnimationController headerController;
  Timer _timer;
  int durationTime = 1500; //错误弹框时间
  // 登录处理中
  bool loginProcessing = false;
  bool phoneisEmpty = false;
  bool codeisEmpty = false;
  int countdownTime = 0;
  bool countdownTimeShow = false;
  bool againLoginShow = true;

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
    ;
    headerController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: tickerProvider,
    );
    headerAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: headerController,
        curve: Curves.easeOut,
      ),
    );

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
    if (!formKey.currentState.validate()) return;

    setModel(() {
      loginProcessing = true;
    });
//    if (phoneisEmpty || codeisEmpty) {
//      setModel(() {
//        loginProcessing = false;
//      });
//      return;
//    };
    if (phoneisEmpty) {
      setModel(() {
        loginProcessing = false;
      });
      return;
    };
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
              child: Text("手机号错误"),
            ),
          ),
        ),
      );
      setModel(() {
        loginProcessing = false;
      });
      return;
    }
    Result<AccessToken> response = await AdminApis.postAccessToken(
        usernameController.text, passwordController.text);

    bool code = response.success;

    if (code) {

      dispatch( authActions.login(response.data.accessToken));

      navigate.pushNamedAndRemoveUntil('/page', (route) {
        return route.settings.name == '/page';
      });
    } else {
      String message = response.message;
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: durationTime),
          backgroundColor: Color(0xFF0079FE),
          content: SizedBox(
            width: double.infinity,
            height: 40,
            child: Center(
              child: Text(message),
            ),
          ),
        ),
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

  void startCountdown() {
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
              child: Text("手机号错误"),
            ),
          ),
        ),
      );
      return;
    }
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
  }
}
