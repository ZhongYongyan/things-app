import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/src/store.dart';

import 'InviteFamilyBloc.dart';

class InviteFamilyPage extends StatefulWidget {
  // const InviteFamilyPage({Key? key}) : super(key: key);

  @override
  State<InviteFamilyPage> createState() => _InviteFamilyPageState();
}

class _InviteFamilyPageState extends BlocState<InviteFamilyPage,InviteFamilyBloc> with TickerProviderStateMixin{
  @override
  InviteFamilyBloc createBloc(Store<StoreState> store) {
    return InviteFamilyBloc(context, store,this);
  }

  @override
  Widget createWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          title: Text(bloc.title,style: TextStyle(color: Color(0xFF2681FF))),
          centerTitle: true,
          shape: Border(bottom: BorderSide(color:Color(0xFF2681FF))),
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: bloc.formKey,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text("${bloc.inviteMemberJoin}\“${bloc.master+bloc.homeSuffix}\“",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF2681FF)
                    )),
                  ),
                  TextFormField(
                    controller: bloc.phoneController,
                    focusNode: bloc.phoneFocus,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: bloc.phoneNumber,
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: true,
                      fillColor: Colors.black,
                      contentPadding: EdgeInsets.all(16.0),
                      hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        bloc.phoneIsEmpty = true;
                      } else {
                        bloc.phoneIsEmpty = false;
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      LengthLimitingTextInputFormatter(11)
                    ],
                  ),
                  SizedBox(height: 10),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black
                    ),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: bloc.codeController,
                            focusNode: bloc.codeFocus,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                            autocorrect: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: bloc.code,
                                filled: true,
                                fillColor: Colors.black,
                                contentPadding: EdgeInsets.all(16.0),
                                hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white)
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                              LengthLimitingTextInputFormatter(6)
                            ],
                            validator: (value) {
                              if (value.isEmpty) {
                                bloc.codeIsEmpty = true;
                              } else {
                                bloc.codeIsEmpty = false;
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
                                      : Color(0xFF2681FF)),
                            ),
                            onTap: () => bloc.startCountdown(), //点击获取验证码
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: ()=>bloc.inviteHandler,
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith((states){
                          return Colors.white;//默认颜色
                        }
                        ),//文字颜色
                        // backgroundColor: MaterialStateProperty.resolveWith(
                        //         (states){
                        //       if(states.contains(MaterialState.pressed)){//按下时的颜色
                        //         return Colors.grey;
                        //       }
                        //       return Color(0xFF0079FE);//默认颜色
                        //     }
                        // )//背景颜色
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            gradient:LinearGradient(
                                begin: Alignment(0.0, -1.0),
                                end: Alignment(0.0, 1.0),
                                colors: [Color.fromRGBO(12, 41, 83, 1), Color(0xFF2681ff)]
                            ),
                            border: Border.all(color: Color(0xFF00ffff)),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text(bloc.invite),
                      )
                  )
                ],
              ),
            )
          ),
        ),
      )
    );
  }

}
