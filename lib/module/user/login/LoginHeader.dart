import 'package:flutter/material.dart';

class LoginHeader extends AnimatedWidget {
  LoginHeader({Animation headerAnimation}) : super(listenable: headerAnimation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: 140 - animation.value * 140.0,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 140,
                child: Center(
                  child: Wrap(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/app_icon_1024.png"),
                        width: 100.0,
                        height: 100,
                      ),
                      SizedBox(
                        width: 100.0,
                        child: Text(
                          '华腾智控',
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        FadeTransition(
          opacity: animation,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              '登录',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xff333333),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
