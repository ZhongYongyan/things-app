import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/src/store.dart';

import 'CreateFamilyBloc.dart';

class CreateFamilyPage extends StatefulWidget {
  // const CreateFamilyPage({Key? key}) : super(key: key);

  @override
  State<CreateFamilyPage> createState() => _CreateFamilyPageState();
}

class _CreateFamilyPageState extends BlocState<CreateFamilyPage, CreateFamilyBloc> {

  @override
  CreateFamilyBloc createBloc(Store<StoreState> store) {
    return CreateFamilyBloc(context, store);
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
        resizeToAvoidBottomInset: false,
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
            padding: EdgeInsets.fromLTRB(20,50,20,20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bloc.homeName,style: TextStyle(color: Colors.white,fontSize: 18)),
                SizedBox(height: 10),
                TextField(
                  // controller:bloc.usernameController,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white
                  ),
                  autocorrect: false,
                  // focusNode: index == 1 ?  bloc.usernameFocus : index == 5 ? bloc.heightFocus :bloc.weightFocus,
                  decoration:InputDecoration(
                    hintText: bloc.homeNamePlaceholder,
                    border:InputBorder.none,
                    disabledBorder:InputBorder.none,
                    enabledBorder:InputBorder.none,
                    focusedBorder:InputBorder.none,
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                    hintStyle:TextStyle(
                        fontSize:14.0,
                        color: Colors.white),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]')),
                    LengthLimitingTextInputFormatter(15)
                  ],
                  onChanged: (value)=>bloc.setName(value),
                ),
                Container(
                  margin: EdgeInsets.only(top: 200),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient:LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0),
                          colors: [Color.fromRGBO(12, 41, 83, 1), Color(0xFF2681ff)]
                      ),
                      border: Border.all(color: Color(0xFF00ffff)),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                              (states){
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
                    child: Text(bloc.submit),
                    onPressed: (){
                      _closeKeyboard(context);
                      bloc.createFamily();
                    },//点击登录
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    /// 键盘是否是弹起状态
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }
}
