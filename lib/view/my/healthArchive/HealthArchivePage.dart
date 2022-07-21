import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/noripple.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:redux/src/store.dart';

import 'HealthArchiveBloc.dart';

class HealthArchivePage extends StatefulWidget {
  // const HealthArchivePage({Key? key}) : super(key: key);

  @override
  State<HealthArchivePage> createState() => _HealthArchivePageState();
}

class _HealthArchivePageState extends BlocState<HealthArchivePage,HealthArchiveBloc> {

  @override
  HealthArchiveBloc createBloc(Store<StoreState> store) {
    return HealthArchiveBloc(context, store);
  }

  @override
  Widget createWidget(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        title: Text(
          bloc.title,
          style: TextStyle(
            color: Colors.black
          ),
        ),
        actions: [
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                        (states){
                      return Color(0xFF02A7F0);//默认颜色
                    }
                ),//文字颜色
              ),
              child: Text(bloc.createLabel),
              onPressed:()=>bloc.toCreateAFamily()
          ),
          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   child: Container(
          //     padding: EdgeInsets.all(10),
          //     alignment: Alignment.center,
          //     child: Text(
          //       bloc.createLabel,
          //       style: TextStyle(
          //           color: Color(0xFF02A7F0),
          //         fontSize: 18
          //       ),
          //     ),
          //   ),
          //   onTap: ()=>bloc.toCreateAFamily(),
          // )
        ],
      ),
      body:SafeArea(
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Container(
              color: Color.fromRGBO(100,214,240,1),
              child: Column(
                children: [
                  Image.network('https://axhub.im/ax9/7daa3ef63e5c1293/images/邀请家人/u12.png'),
                  Container(
                    margin: EdgeInsets.all(10),
                    transform: Matrix4.translationValues(0, -30, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white
                    ),
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${bloc.currentHome['name']}${bloc.homeSuffix}",style: TextStyle(
                                fontSize: 20
                            ),),
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color.fromRGBO(64,158,255,1),
                                ),
                                padding: EdgeInsets.fromLTRB(10,5,10,5),
                                child: Row(
                                  children: [
                                    Icon(Icons.swap_horiz,color: Colors.white),
                                    Text(bloc.exchangeHome,style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white
                                    ))
                                  ],
                                ),
                              ),
                              onTap: (){
                                _exchangeFamily();
                                // bloc.toItemLocation(bloc.selectedIndex);
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                // padding: EdgeInsets.fromLTRB(10,3,10,3),
                                child: Row(
                                  children: [
                                    Text(bloc.manageFamily,style: TextStyle(
                                        fontSize: 15
                                    )),
                                    Icon(Icons.navigate_next)
                                  ],
                                ),
                              ),
                              onTap: ()=>bloc.manageHome(),
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        GridView.count(
                            padding: EdgeInsets.zero,
                            // gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                            //
                            // ),
                            crossAxisCount: 3,
                            mainAxisSpacing: 5.0,
                            crossAxisSpacing:35.0,
                            childAspectRatio: 0.8,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: _getGridData(),
                            // itemCount: bloc.myFamily.length+1,//加1是为了多一个邀请按钮
                            // itemBuilder: this._getGridData

                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      )
    );
  }

  List<Widget> _getGridData(){
    List<Widget> list = [];
    for (var i = 0; i < bloc.myFamily.length; i++) {
      list.add(GestureDetector(
        child: Container(
          child: Column(
              children:[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      image: DecorationImage(
                          image: NetworkImage(bloc.myFamily[i]['img']),
                          fit: BoxFit.cover
                      )
                  ),
                  child: bloc.myFamily[i]['creator']?
                  Align(
                      alignment: Alignment(0,0.8),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          widthFactor: 1.2,
                          heightFactor: 1,
                          child: Text(bloc.creator,style: TextStyle(
                              color: Colors.white,
                              fontSize: 12
                          ),
                          ),
                        ),
                      )
                  ):Container(),
                ),
                SizedBox(height: 8),
                Text(bloc.myFamily[i]['name'],
                    maxLines: 1,
                    textAlign:TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14,height: 1)
                )
              ]
          ),
        ),
        onTap: ()=>bloc.viewDetails(i),
      ));
    }
    list.add(Container(
      child: Column(
          children:[
            GestureDetector(
              child: Container(
                  width:80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(80)
                  ),
                  child: Icon(Icons.add_rounded,color: Colors.white,size: 70)
              ),
              onTap: ()=>bloc.toInvite(),
            ),
            SizedBox(height: 8),
            Text(bloc.inviteFamily,
                maxLines: 1,
                textAlign:TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14,height: 1)
            )
          ]
      ),
    ));
    return list;
  }

  //切换家庭
  _exchangeFamily(){
    _listController = ScrollController(initialScrollOffset: bloc.selectedIndex*bloc.itemHeight);//跳转到指定item
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ct) {
        return StatefulBuilder(
            builder: (context1,state){
              return Container(
                height: 600,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(bloc.exchangeHome,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                          ),
                          Positioned(
                              right: 0,
                              child: GestureDetector(
                                  onTap: ()=>Navigator.pop(context1),
                                  child: Icon(Icons.close,size: 20,)
                              )
                          )
                        ],
                      )
                    ),
                    Expanded(
                      child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.separated(
                            controller: _listController,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: bloc.myHome.length,
                            itemBuilder: (_, index){
                              return InkWell(
                                // behavior: HitTestBehavior.opaque,//当GestureDetector存在child时默认点击响应区域为child，所以此处修改为范围响应
                                child: Container(
                                  height: bloc.itemHeight,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text("${bloc.myHome[index]['name']}${bloc.homeSuffix}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: bloc.selectedIndex==index?Color.fromRGBO(64,158,255,1):Colors.black
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  print(index);
                                  Navigator.pop(ct);
                                  state((){
                                    bloc.selectedIndex=index;
                                  });
                                  // bloc.chooseHome(index);
                                },
                              );
                            },
                            separatorBuilder: (context, index) => Container(
                              height: 1,
                              color: Color(0xFFF3F3F3),
                            ),
                          )
                      ),
                    )
                  ],
                )
              );
            }
        );//showModalBottomSheet相当于打开一个新的页面，所以不可直接使用setData更新它里面的数据，需要包裹上StatefulBuilder并创建一个新的setData方法，即state
      },
    );
  }
  ScrollController _listController = ScrollController();
  @override
  void dispose(){
    _listController.dispose();
    super.dispose();
  }

}
