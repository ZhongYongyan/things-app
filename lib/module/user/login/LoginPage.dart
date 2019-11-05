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
//        appBar: AppBar(
//          elevation: 0.0,
//          leading: ColorIconButton(
//            icon: Icon(MyIcons.cross),
//            onPressed: bloc.backHandler,
//          ),
//        ),
        body: body,
      ),
    );
  }

  Widget _pageBody() {
    return Form(
      key: bloc.formKey,
      child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SafeArea(
            child: Column(
              children: <Widget>[
//              Container(
//                alignment: Alignment.center,
//                child: Image(
//                  image: AssetImage("assets/screen_image_0.jpeg"),
//                  fit:BoxFit.cover,
//                  width: 300,
//                  height: 300,
//                ),
//              ),
                LoginHeader(headerAnimation: bloc.headerAnimation),
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(color: Color(0xFFF3F3F3), width: 1),
                          right: BorderSide(color: Color(0xFFF3F3F3), width: 1),
                          top: BorderSide(color: Color(0xFFF3F3F3), width: 1),
                          bottom:
                              BorderSide(color: Color(0xFFF3F3F3), width: 0.5)),
                      //borderRadius: BorderRadius.circular(0.0), //3像素圆角
                    ),
                    child: TextFormField(
                      controller: bloc.usernameController,
                      focusNode: bloc.usernameFocus,
                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: '请输入手机号码',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.phone_iphone,
                          color: Color(0xFFcccccc),
                        ),
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(14.0),
                        hintStyle: bloc.phoneisEmpty
                            ? TextStyle(
                                fontSize: 14.0, color: Color(0xFFEC4D5C))
                            : TextStyle(
                                fontSize: 14.0, color: Color(0xFFcccccc)),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          bloc.phoneisEmpty = true;
                        } else {
                          bloc.phoneisEmpty = false;
                        }
                      },
                    ),
                  ),
                ),

                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(color: Color(0xFFF3F3F3), width: 1),
                        right: BorderSide(color: Color(0xFFF3F3F3), width: 1),
                        top: BorderSide(color: Color(0xFFF3F3F3), width: 0.5),
                        bottom: BorderSide(color: Color(0xFFF3F3F3), width: 1)),
                    //borderRadius: BorderRadius.circular(0.0), //3像素圆角
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: bloc.passwordController,
                          focusNode: bloc.passwordFocus,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          obscureText: true,
                          autocorrect: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Color(0xFFcccccc),
                            ),
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: '请输入短信验证码',
                            contentPadding: EdgeInsets.all(14.0),
                            hintStyle: bloc.codeisEmpty
                                ? TextStyle(
                                    fontSize: 14.0, color: Color(0xFFEC4D5C))
                                : TextStyle(
                                    fontSize: 14.0, color: Color(0xFFcccccc)),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              bloc.codeisEmpty = true;
                            } else {
                              bloc.codeisEmpty = false;
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        width: 100,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          child: Text(
                            bloc.countdownTimeShow
                                ? bloc.countdownTime.toString() + "S后重发"
                                : "获取验证码",
                            style: TextStyle(
                                fontSize: 12.0, color: Color(0xFF0079FE)),
                          ),
                          onTap: () => bloc.startCountdown(), //点击
                        ),
                      ),
                    ],
                  ),
                ),

//            Container(
//              alignment: Alignment.centerRight,
//              child: ColorTextButton(
//                '忘记密码',
//                onPressed: bloc.forgetPasswordHandler,
//              ),
//            ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      color: Color(0xFF0079FE),
                      child: loginText(),
                      onPressed: bloc.loginHandler,
                    ),
                  ),
                )

//            Padding(
//              padding: EdgeInsets.only(top: 20.0),
//              child: SizedBox(
//                width: double.infinity,
//                child: FlatButton(
//                  shape: new RoundedRectangleBorder(
//                    side: BorderSide(color: Color(0xffE3E3E3)),
//                    borderRadius: new BorderRadius.circular(5.0),
//                  ),
//                  color: appTheme.buttonTheme.colorScheme.secondary,
//                  child: Text("注册"),
//                  onPressed: bloc.registerHandler,
//                ),
//              ),
//            ),
              ],
            ),
          )),
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
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              Text(
                '登录中',
                style: TextStyle(color: Colors.white),
              ),
            ],
          )
        : Text(
            '登录',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          );
  }
}
