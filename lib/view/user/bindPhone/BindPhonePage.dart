import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/redux.dart';

import 'BindPhoneBloc.dart';

class BindPhonePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<BindPhonePage, BindPhoneBloc>
    with TickerProviderStateMixin {
  @override
  BindPhoneBloc createBloc(Store<StoreState> store) {
    return BindPhoneBloc(context, store, this);
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

  _pageBody(){
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('绑定手机',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  child: Form(
                    key: bloc.formKey,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(30,100,30,0),
                        child: SafeArea(
                          child: Column(
                            children: <Widget>[
                              DecoratedBox(
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1.0,color: Colors.grey[300]),
                                    borderRadius: BorderRadius.all(Radius.circular(50))
                                  //borderRadius: BorderRadius.circular(0.0), //3像素圆角
                                ),
                                child: TextFormField(
                                  controller: bloc.usernameController,
                                  focusNode: bloc.usernameFocus,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black),
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    hintText: bloc.phoneNumber,
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.phone_iphone,
                                      color: Color(0xFFF56C6C),
                                    ),
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.all(16.0),
                                    hintStyle: TextStyle(
                                        fontSize: 16.0,
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
                              SizedBox(height: 20,),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1.0,color: Colors.grey[300]),
                                    borderRadius: BorderRadius.all(Radius.circular(50))
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
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                        autocorrect: false,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            prefixIcon: Icon(
                                              Icons.mail,
                                              color: Color(0xFFF56C6C),
                                            ),
                                            disabledBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText: bloc.code,
                                            contentPadding: EdgeInsets.all(16.0),
                                            hintStyle: TextStyle(
                                                fontSize: 16.0,
                                                color: Color(0xFFcccccc))
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
                                              bloc.resetCode
                                              : bloc.getCode,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: bloc.countdownTimeShow
                                                  ? Color(0xFFcccccc)
                                                  : Color(0xFFF56C6C)),
                                        ),
                                        onTap: () => bloc.startCountdown(), //点击获取验证码
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 30.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        foregroundColor: MaterialStateProperty.resolveWith(
                                                (states){
                                              return Color(0xFFFE7C1C);//默认颜色
                                            }
                                        ),//文字颜色
                                        backgroundColor: MaterialStateProperty.resolveWith(
                                                (states){
                                              if(states.contains(MaterialState.pressed)){//按下时的颜色
                                                return Colors.grey;
                                              }
                                              return Color(0xFFF56C6C);//默认颜色
                                            }
                                        )//背景颜色
                                    ),
                                    child: loginText(),
                                    onPressed: bloc.loginHandler,//点击登录
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  )
              )
            ],
          )
      ),
    );
  }

  Widget loginText() {
    return Container(
        height: 36.0,
        alignment: Alignment.center,
        child: bloc.loginProcessing?
        SpinKitThreeBounce(
          color: Colors.white,
          size: 18,
        )
            :Text(
          bloc.bindPhone,
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        )
    );
  }

}
