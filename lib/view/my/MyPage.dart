import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:app/view/home/user/component/ActionSheet.dart';
import 'package:app/view/home/user/component/lib/src/date_format.dart';
import 'package:app/view/my/MyBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

class MyPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<MyPage, MyBloc> {
  @override
  MyBloc createBloc(Store<StoreState> store) {
    return MyBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    bloc.h = MediaQuery.of(context).size.height;
    Widget body = _pageBody();
    return body;
  }

  _pageBody() {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: CustomScrollView(
        slivers: [
          _headerInfo(),
          // _sliverGridButtons()
          _myServices(),
          _myInfo()

        ],
      )
    );
  }

  //用户基础信息
  Widget _headerInfo(){
    return SliverToBoxAdapter(
      child: Container(
        // margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        padding:EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top, 0, 0),
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
            aspectRatio: 4.0/3.0,
            child: Container(
              decoration:BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage('https://axhub.im/ax9/7daa3ef63e5c1293/images/个人中心/u124.png'),
                      fit: BoxFit.cover
                  )
              ),
              child: Stack(
                alignment: Alignment.topLeft, //指定未定位或部分定位widget的对齐方式
                children: <Widget>[
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 45.0,
                      height: 45.0,
                      child: Icon(Icons.notifications,size: 18,color: Colors.white),
                    ),
                  ),
                  Positioned(
                      top: 53.0,
                      left:24.0 ,
                      right: 24.0,
                      child: Row(
                        children: [
                          GestureDetector(
                            child: CircleAvatar(
                                radius:35.0,
                                foregroundImage:AssetImage("assets/home_y.png"),
                                // backgroundImage:NetworkImage(bloc.imgPath)
                            ),
                            onTap: () => {
                              BottomActionSheet.show(
                                  context,
                                  [
                                    bloc.camera,
                                    bloc.album
                                  ],
                                  cancel: bloc.cancel,
                                  title: '',
                                  callBack: (i) {
                                    if (i == 0) {
                                      bloc.takePhoto();
                                    }
                                    else if (i == 1) {
                                      bloc.openGallery();
                                    }
                                    return;
                                  }),
                            },
                          ),
                          Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      child: Text('18867674354',style: TextStyle(fontSize: 16.0,color: Colors.white),overflow: TextOverflow.ellipsis),
                                      onTap: () => {

                                      },
                                    ),
                                    GestureDetector(
                                      child: Text('Lv1 距离下个等级仅需146546成长值 >',style: TextStyle(fontSize: 14.0,color: Colors.white),overflow: TextOverflow.ellipsis),
                                      onTap: bloc.memberBenefits,
                                    ),
                                  ],
                                ),
                              )

                          )
                        ],
                      )
                  ),
                  Positioned(
                    top: 161.0,
                    left: 24.0,
                    right: 24.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Center(
                              child:Container(
                                width: 118.0,
                                height: 61.0,
                                child: Column(
                                  children: [
                                    Text('1000',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w700,color: Colors.white)),
                                    Text('积分',style: TextStyle(fontSize: 12.0,color: Colors.white)),
                                  ],
                                ),
                              )
                          ),
                          onTap:()=>{

                          }
                        ),
                        GestureDetector(
                          child: Center(
                            child: Container(
                              width: 118.0,
                              height: 61.0,
                              child: Column(
                                children: [
                                  Text('会员等级',style: TextStyle(fontSize: 16.0,color: Colors.white)),
                                  Text('Lv1',style: TextStyle(fontSize: 12.0,color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          onTap: bloc.memberBenefits,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  //我的服务
  Widget _myServices(){
    return SliverToBoxAdapter(
      child: Card(
        margin: EdgeInsets.all(10.0),
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide.none
        ),
        child: Column(
          children: [
            Container(
              width:500,
              padding:EdgeInsets.all(10.0),
              child: Text(bloc.service,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),textAlign: TextAlign.left),
            ),
            Divider(height: 1.0,thickness:1.0,indent: 0.0,color: Colors.grey[300]),
            Container(
              padding: EdgeInsets.all(10.0),
                child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 0.0,
                        crossAxisSpacing:2.0,
                        childAspectRatio: 1.0
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: bloc.myServices.length,
                    itemBuilder: this._getGridData

                )
            )//在Column或Row内使用GridView或List时需要在外面套一个有宽高度的壳，因为GridView或List需要向父级盒子进行定位，而Column或Row本身没有大小
          ],
        ),
      ),
    );
  }

  //我的信息
  Widget _myInfo(){
    return SliverToBoxAdapter(
      child: Card(
          margin: EdgeInsets.all(10.0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide.none
          ),
          child: Column(
            children: [
              Container(
                width:500,
                padding:EdgeInsets.all(10.0),
                child: Text(bloc.information,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),textAlign: TextAlign.left,),
              ),
              Divider(height: 1.0,thickness:1.0,indent: 0.0,color: Colors.grey[300]),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),//禁止滚动
                  itemCount: bloc.myInfo.length,
                  itemBuilder: this._getInfoData,
                ),
              )
            ],
          )
      )
    );
  }

  Widget _getGridData(content,index){
    return GestureDetector(
      child: Column(
        children:[
          Container(
            padding: EdgeInsets.all(5.0),
            child: Image.asset('assets/home_y.png',width: 40.0,height: 40.0,),
          ),
          Text(bloc.myServices[index]['title'],style: TextStyle(fontSize: 14),)
        ]
      ),
      onTap: ()=>bloc.chooseServices(index),
    );
  }

  Widget _getInfoData(content,index){
    return GestureDetector(
      child: Container(
        child: ListTile(
          leading: Image.asset('assets/home_y.png',fit: BoxFit.cover,width: 30.0,height: 30.0,),
          title: Text(bloc.myInfo[index]['title'],style: TextStyle(fontSize: 16.0),),
          trailing: Icon(Icons.navigate_next,size: 18,color: Colors.grey[300],),
        ),
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide.none,
              left: BorderSide.none,
              right: BorderSide.none,
              bottom: index==bloc.myInfo.length-1?BorderSide.none: BorderSide(width: 1.0,color: Colors.grey[300]),
            )
        ),
      ),
      onTap: ()=>bloc.viewInfo(index),
    );
  }

}
