import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/redux.dart';

import 'LoginBloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<LoginPage, LoginBloc>
    with TickerProviderStateMixin {

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
        resizeToAvoidBottomInset:false,
        body: body,
      ),
    );
  }

  Widget _pageBody() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.grey[100]),
          child: Form(
            key: bloc.formKey,
            child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 40.0, bottom: 10),
                        alignment: Alignment.center,
                        child: Image(
                          image: NetworkImage('https://axhub.im/ax9/7daa3ef63e5c1293/images/%E5%90%AF%E5%8A%A8%E7%95%8C%E9%9D%A2/u8.png'),
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                      ),
                      Container(
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
                              color: Colors.white
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
                                color: Color(0xFFcccccc),
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
                      ),
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
                            color: Colors.white
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
                                    color: Color(0xFFcccccc),
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
                                          : Color(0xFF0079FE)),
                                ),
                                onTap: () => bloc.startCountdown(), //点击获取验证码
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
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
                                      return Color(0xFF0079FE);//默认颜色
                                    }
                                )//背景颜色
                            ),
                            child: loginText(),
                            onPressed: bloc.loginHandler,//点击登录
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 1,
                                child:Divider(height: 1.0,thickness:1.0,indent: 0.0,endIndent: 5.0,color: Color(0xFFE3E3E3))
                            ),
                            Text(
                              '其他登录方式',
                              style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 16
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child:Divider(height: 1.0,thickness:1.0,indent: 5.0,color: Color(0xFFE3E3E3))
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: GestureDetector(
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/wechat.png",
                                  width: 60.0,
                                  height: 60.0,
                                  fit: BoxFit.cover,
                                ),
                                Text('微信',
                                  style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 15,
                                      height: 2.0
                                  ),
                                )
                              ],
                            ),
                            onTap: ()=>bloc.wxLogin(),
                          )
                      ),
                    ],
                  ),
                )),
          )
        ),
        bloc.registerSuccess?registerSuccess():Container()
      ],
    );
  }

  // Widget loginText() {
  //   return bloc.loginProcessing
  //       ? Wrap(
  //           spacing: 8.0,
  //           runSpacing: 4.0,
  //           alignment: WrapAlignment.center,
  //           children: <Widget>[
  //             SizedBox(
  //               width: 40,
  //               child: Padding(
  //                 padding: EdgeInsets.all(4),
  //                 child: SpinKitThreeBounce(
  //                   color: Colors.white,
  //                   size: 16,
  //                 ),
  //               ),
  //             ),
  //             Text(
  //               '',
  //               style: TextStyle(color: Colors.white),
  //             ),
  //           ],
  //         )
  //       : Padding(
  //           padding: EdgeInsets.all(4),
  //           child: Text(
  //             bloc.login,
  //             style: TextStyle(fontSize: 18.0, color: Colors.white),
  //           )
  //         );
  // }

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
          bloc.login,
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        )
    );
  }

  /*
   *注册成功
   */
  Widget registerSuccess(){
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        top: 0,
        child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.8),
            // margin: EdgeInsets.only(top: 100,bottom: 100),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(0,0.22),
                  child: registerSuccessPic(),

                ),
                Align(
                  alignment: Alignment(0,-0.2),
                  child: registerSuccessTip(),
                )
              ],
            )

        )
    );
  }
  /*
  * 注册成功弹窗提示
  * */
  Widget registerSuccessTip(){
    return Container(
      key: ValueKey('A'),
      width: 400,
      height: 480,
      padding: EdgeInsets.only(bottom: 80),
      child: Stack(
        children: [
          Align(
            child: RotationTransition(
              //设置动画的旋转中心
              alignment: Alignment.center,
              //动画控制器
              turns: bloc.headerController,
              child: Container(
                decoration: BoxDecoration(
                  image:DecorationImage(
                    image: NetworkImage('https://axhub.im/ax9/7daa3ef63e5c1293/images/%E7%99%BB%E5%BD%95%E6%B3%A8%E5%86%8C%E9%A1%B5%E9%9D%A2/u168.png'),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0,-0.18),
              child: Image.network('https://axhub.im/ax9/7daa3ef63e5c1293/images/登录注册页面/u172.png',
                  width: 60,
                  fit: BoxFit.cover
              )
          ),
          Align(
              // alignment: Alignment(0,-0.2),
              child: Container(
                width: 220,
                padding: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  image:DecorationImage(
                    image: NetworkImage(
                        'https://axhub.im/ax9/7daa3ef63e5c1293/images/登录注册页面/u169.png',
                    ),
                  ),
                  // color: Color(0xFFFF542C),
                  // borderRadius: BorderRadius.circular(1000)
                ),
                child: Text('恭喜注册成功',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromRGBO(232, 177, 35, 1),
                        fontWeight: FontWeight.w700,
                    )
                ),
              )
          ),

        ],
      ),
    );
  }

  /*
  * 注册成功弹窗图片，显示用户是当前省市第几位注册用户，点击确认时进入首页
  * */
  Widget registerSuccessPic(){
    return Container(
        key:ValueKey('B'),
        width: 279,
        height: 225,
        padding: EdgeInsets.only(top: 33),
        decoration: BoxDecoration(
          image:DecorationImage(
            image: NetworkImage('https://axhub.im/ax9/7daa3ef63e5c1293/images/登录注册页面/u164.png'),
          ),
        ),
        child: Column(
          children: [
            Text('您已成为',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF60808),
                height: 2
              )
            ),
            Text('广东省广东市',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFFF60808),
                  height: 2
              ),
            ),
            Text('第XXX名注册用户',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFFF60808),
                  height: 2
              ),
            ),
            SizedBox(height: 43,),
            GestureDetector(
              child: Text('确 定',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFE64457),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 2
                ),
              ),
              onTap: bloc.ensureRegister,
            )

          ],
        )
    );
  }
}
