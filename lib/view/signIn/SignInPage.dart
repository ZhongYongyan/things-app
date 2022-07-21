import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/signIn/signInBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:redux/src/store.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends BlocState<SignInPage, SignInBloc> {
  @override
  SignInBloc createBloc(Store<StoreState> store) {
    return SignInBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

  _pageBody() {
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
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            title: Text(bloc.title,
                style: TextStyle(
                  color: Color(0xFF2681FF),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                )),
            shape: Border(bottom: BorderSide(color:Color(0xFF2681FF))),
            actions: [
              InkWell(
                child: Row(
                  children: [
                    Text(
                      bloc.pointDetail,
                      style: TextStyle(fontSize: 15),
                    ),
                    Icon(Icons.navigate_next,size: 20),
                    SizedBox(width: 20)
                  ],
                ),
                // onTap: bloc.toPointDetail(),
              )
            ],
          ),
          body: SafeArea(
            child: Container(
                margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(20),
                      decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(179, 230, 222, 0.1)
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(10.0),
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 20,
                                alignment: WrapAlignment.center,
                                children: _signDay(),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF2681FF)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${bloc.pointRule}:",style: TextStyle(color: Colors.white),),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            //禁止滚动
                            itemCount: bloc.rules.length,
                            itemBuilder: this._getRules,
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        )
      );
  }

  //规则样式
  Widget _getRules(content, index) {
    return RichText(
      text: TextSpan(
          text: "${index + 1}.",
          children: [
            TextSpan(text: bloc.rules[index]),
            TextSpan(
                text:
                    index == bloc.rules.length ? bloc.fullStop : bloc.semicolon)
          ]),
    );
  }

  /*
  * 签到天数
  * */
  List<Widget> _signDay() {
    //map后面要写Widget，不然会报list<dynamic> is not a subtype of type list<Widget>
    var tempList = bloc.signDays.map<Widget>((e) {
      return Container(
        padding: EdgeInsets.fromLTRB(15,10,15,10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient:LinearGradient(
                begin: Alignment(0.0, -1.0),
                end: Alignment(0.0, 1.0),
                colors: [Color.fromRGBO(12, 41, 83, 1), Color(0xFF2681ff)]
            )
        ),
        // width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(e,style: TextStyle(color: Colors.white)),
            // Image.network(src),
            Text("+${50}",style: TextStyle(color: Colors.white),)
          ],
        ),
      );
    });
    return tempList.toList();
  }
}
