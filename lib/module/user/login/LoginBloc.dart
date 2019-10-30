import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

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

  // 登录处理中
  bool loginProcessing = false;

  LoginBloc(
    BuildContext context,
    Store<StoreState> store,
    TickerProvider tickerProvider,
  ) : super(context, store) {
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

    Dio dio = new Dio();
    dio.options.baseUrl = 'http://things.dev.jiaedian.net/api/2.1.0';
    dio.options.headers.addAll({
      'AppCode': 'THINGS',
      'ClientId': '58ef798fe70f4cc59610d73471b23051',
    });

    Response response = await dio.post("/passport/get-token", data: {
      'ClientId': 'user',
      'ClientSecret': 'web',
      'Username': usernameController.text,
      'Password': passwordController.text,
    });

    log.info(response.data.toString());

    int code = response.data['Code'];
    if (code == 0) {
      //dispatch(AuthLoginAction(username: usernameController.text));
      //navigate(NavigateToAction.replace('/home'));
      navigate.pushNamedAndRemoveUntil('/home', (route) {
        return route.settings.name == '/home';
      });
    } else {
      String message = response.data['Message'];
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Color(0xff46ceb7),
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
}
