import 'package:app/component/ColorIconButton.dart';
import 'package:app/component/ColorTextButton.dart';
import 'package:app/config/AppTheme.dart';
import 'package:app/module/user/login/LoginBloc.dart';
import 'package:app/module/user/login/LoginHeader.dart';
import 'package:app/packages.dart';
import 'package:app/store/Store.dart';
import 'package:app/util/icon/my_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/redux.dart';

class LoginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<LoginPage, LoginBloc>
    with SingleTickerProviderStateMixin {
  @override
  LoginBloc createBloc(Store<StoreState> store) {
    return LoginBloc(context, store, this);
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return _pageHead(body: body);
  }

  Widget _pageHead({@required Widget body}) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        key: bloc.scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          leading: ColorIconButton(
            icon: Icon(MyIcons.cross),
            onPressed: bloc.backHandler,
          ),
        ),
        body: body,
      ),
    );
  }

  Widget _pageBody() {
    return Form(
      key: bloc.formKey,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          children: <Widget>[
            LoginHeader(headerAnimation: bloc.headerAnimation),
            TextFormField(
              controller: bloc.usernameController,
              focusNode: bloc.usernameFocus,
              style: TextStyle(fontSize: 20.0, color: Colors.black),
              autocorrect: false,
              decoration: InputDecoration(
                hintText: '账号',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return '请输入账号';
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              controller: bloc.passwordController,
              focusNode: bloc.passwordFocus,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              obscureText: true,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: '密码',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return '请输入密码';
                }
              },
            ),
            Container(
              alignment: Alignment.centerRight,
              child: ColorTextButton(
                '忘记密码',
                onPressed: bloc.forgetPasswordHandler,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FlatButton(
                color: appTheme.buttonTheme.colorScheme.primary,
                child: loginText(),
                onPressed: bloc.loginHandler,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xffE3E3E3)),
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  color: appTheme.buttonTheme.colorScheme.secondary,
                  child: Text("注册"),
                  onPressed: bloc.registerHandler,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginText() {
    return bloc.loginProcessing
        ? Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 40,
                child: Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: SpinKitThreeBounce(
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              ),
              Text(
                '登录中',
                style: TextStyle(color: Colors.white54),
              ),
            ],
          )
        : Text('登录');
  }
}
