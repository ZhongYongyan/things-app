import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/redux.dart';

import 'WxAuthBloc.dart';

class WxAuthPage extends StatefulWidget {
  @override
  State<WxAuthPage> createState() => _WxAuthPageState();
}

class _WxAuthPageState extends BlocState<WxAuthPage , WxAuthBloc> {

  @override
  WxAuthBloc createBloc(Store<StoreState> store) {
    return WxAuthBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

  _pageBody(){
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(30,20,30,20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.network(
                      'https://axhub.im/ax9/7daa3ef63e5c1293/images/登录注册页面/u58.png',
                      width: 45,
                      height: 45,
                    ),
                    Text(
                        'iRest 健康云 申请使用',
                        style: TextStyle(
                          fontSize: 18
                        ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(
                    '获取你的昵称、头像',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: Color(0xFFDDDDDD),
                            width: 1),
                        bottom: BorderSide(
                            color: Color(0xFFDDDDDD),
                            width: 1)),
                  ),
                  child: ListTile(
                    leading: Image.asset('assets/home_y.png',fit: BoxFit.cover,width: 50.0,height: 50.0,),
                    title: Text('哈哈哈',style: TextStyle(fontSize: 18.0),),
                    subtitle: Text('微信昵称头像',style: TextStyle(fontSize: 16.0),)
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: ()=>bloc.auth(),
                            style: ButtonStyle(
                                backgroundColor:MaterialStateProperty.resolveWith(
                                        (states){
                                      return Color(0xFF28C445);
                                    }
                                ),
                                padding:MaterialStateProperty.all(EdgeInsets.all(10)),
                                minimumSize: MaterialStateProperty.all(Size(200, 50)),
                                elevation: MaterialStateProperty.all(0)
                            ),
                            child: Text('允许')
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: (){},
                            style: ButtonStyle(
                                backgroundColor:MaterialStateProperty.resolveWith(
                                        (states){
                                      return Color.fromRGBO(102, 102, 102, 0.1);
                                    }
                                ),
                                foregroundColor: MaterialStateProperty.resolveWith(
                                        (states){
                                      return Color(0xFF28C445);
                                    }
                                ),
                                padding:MaterialStateProperty.all(EdgeInsets.all(10)),
                                minimumSize: MaterialStateProperty.all(Size(200, 50)),
                                elevation: MaterialStateProperty.all(0)
                            ),
                            child: Text('拒绝')
                        )
                      ],
                    ),
                  ),
                )

              ],
            )
          )
      ),
    );
  }
}
