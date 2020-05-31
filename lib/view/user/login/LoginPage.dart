import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/redux.dart';

import 'LoginBloc.dart';

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
        body: body,
      ),
    );
  }

  Widget _pageBody() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            child: SingleChildScrollView(
              child: Form(
                key: bloc.formKey,
                child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: SafeArea(
                      child: Column(
                        children: <Widget>[
                          bloc.againLoginShow
                              ? Container(
                            margin: const EdgeInsets.only(
                                top: 34.0, bottom: 10),
                            alignment: Alignment.center,
                            child: Image(
                              image: AssetImage(
                                  "assets/u252.png"),
                              fit: BoxFit.cover,
                              width: 270,
                              height: 239,
                            ),
                          )
                              : Container(
                            margin: const EdgeInsets.only(
                                top: 100.0, bottom: 60),
                            child: Center(
                              child: Wrap(
                                direction: Axis.vertical,
                                children: <Widget>[
                                  Container(
                                    width: 200,
                                    child: ClipOval(
                                      child: Image.network(
                                        'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
                                        width: 72,
                                        height: 72,
                                        //fit: BoxFit.cover,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                  Container(
                                    width: 200,
                                    margin:
                                    const EdgeInsets.only(top: 10.0),
                                    alignment: Alignment.center,
                                    child:
                                    Text(bloc.usernameController.text.replaceRange(3, 7, "****"),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xFF999999),
                                          fontWeight: FontWeight.w700,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                          //LoginHeader(headerAnimation: bloc.headerAnimation),
                          bloc.againLoginShow
                              ? Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        color: Color(0xFFF3F3F3),
                                        width: 1),
                                    right: BorderSide(
                                        color: Color(0xFFF3F3F3),
                                        width: 1),
                                    top: BorderSide(
                                        color: Color(0xFFF3F3F3),
                                        width: 1),
                                    bottom: BorderSide(
                                        color: Color(0xFFF3F3F3),
                                        width: 0.5)),
                                //borderRadius: BorderRadius.circular(0.0), //3像素圆角
                              ),
                              child: TextFormField(
                                controller: bloc.usernameController,
                                focusNode: bloc.usernameFocus,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.black),
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
                                      fontSize: 14.0,
                                      color: Color(0xFFEC4D5C))
                                      : TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFcccccc)),
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
                          )
                              : Container(),

                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Color(0xFFF3F3F3), width: 1),
                                  right: BorderSide(
                                      color: Color(0xFFF3F3F3), width: 1),
                                  top: BorderSide(
                                      color: Color(0xFFF3F3F3),
                                      width: bloc.againLoginShow ? 0.5 : 1),
                                  bottom: BorderSide(
                                      color: Color(0xFFF3F3F3), width: 1)),
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
                                          fontSize: 14.0,
                                          color: Color(0xFFEC4D5C))
                                          : TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFFcccccc)),
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
                                          ? bloc.countdownTime.toString() +
                                          "S后重发"
                                          : "获取验证码",
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Color(0xFF0079FE)),
                                    ),
                                    onTap: () => bloc.startCountdown(), //点击
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                          ),
                          bloc.againLoginShow
                              ? Container()
                              : Container(
                            margin: const EdgeInsets.only(top: 40.0),
                            child: GestureDetector(
                                child: Text("其他账户登录",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFF0079FE),
                                      fontWeight: FontWeight.w700,
                                    )),
                                onTap: () => bloc.againlog()),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ),
      ],
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
          '',
          style: TextStyle(color: Colors.white),
        ),
      ],
    )
        : Text(
      '登录/注册',
      style: TextStyle(fontSize: 16.0, color: Colors.white),
    );
  }
}
