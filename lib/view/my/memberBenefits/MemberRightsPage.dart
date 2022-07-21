import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:app/view/my/memberBenefits/MemberRightsBloc.dart';
import 'package:redux/redux.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
class MemberRightsPage extends StatefulWidget {
  @override
  State<MemberRightsPage> createState() => _MemberRightsPageState();
}

class _MemberRightsPageState extends BlocState<MemberRightsPage, MemberRightsBloc> {
  @override
  MemberRightsBloc createBloc(Store<StoreState> store) {
    return MemberRightsBloc(context, store);
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

  _pageBody(){
    return Scaffold(
        key: bloc.scaffoldKey,
        backgroundColor: Color(0xFFF8F8F8),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(bloc.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: AspectRatio(
                        aspectRatio: 16/7,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(5,0,5,0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                      image: NetworkImage(bloc.levels[bloc.currentLevel]['backgroundImg']),
                                      fit: BoxFit.cover
                                  )
                              ),
                              child:Container(
                                margin: EdgeInsets.fromLTRB(30, 40, 30, 40),
                                // color:Colors.white,
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('LV.'+bloc.levels[bloc.currentLevel]['level']+' '+bloc.levels[bloc.currentLevel]['name']+bloc.member,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        bloc.userLevel==index ?
                                        Row(
                                          children: [
                                            Text(bloc.myPoint,
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  height: 1.5

                                              ),),
                                            Text('/'+bloc.levels[bloc.currentLevel]['condition'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  height: 1.5
                                              )),
                                          ],
                                        ):
                                        Container(),
                                      ],
                                    ),

                                    // LinearProgressIndicator(
                                    //   value: 0.5,
                                    //   backgroundColor: Colors.white,
                                    //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    // ),
                                    // Text('LV.'+bloc.levels[bloc.currentLevel]['level']+' '+bloc.levels[bloc.currentLevel]['name']+bloc.member),
                                    Text(bloc.userLevel==index
                                        ? bloc.nextLevelTip+bloc.differenceToNextLevel+bloc.growthValue
                                        : bloc.userLevel>index
                                      ? bloc.preLevelTip
                                      :bloc.nextLevelTip,
                                      style: TextStyle(
                                          fontSize: 15
                                      ),),
                                  ],
                                ),
                              ),
                            );
                          },
                          duration: 70,
                          itemCount: bloc.levels.length,
                          loop: false,
                          viewportFraction: 0.9,
                          onIndexChanged: (index)=>{
                            bloc.indexChanged(index)
                          },
                          index: bloc.currentLevel,
                        )
                    ),
                  ),
                  benefitsWrap('A',bloc.levels[bloc.currentLevel]['name']+bloc.member+bloc.rights,bloc.levels[bloc.currentLevel]['rights'],true),
                  bloc.currentLevel<=bloc.userLevel
                      ? benefitsWrap('B',bloc.rewardsForLevelUp,bloc.rewards,false)
                      :Container()
                ],
            ),
          ),
        )
    );
  }

  //卡片样式模板
  Widget benefitsWrap(key,title,benefits,isBenefits){
    return Card(
        key: ValueKey(key),
        margin: EdgeInsets.all(10),
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child:Column(
          children: [
            Container(
                padding: EdgeInsets.all(12),
                alignment: Alignment.topLeft,
                child: Text(title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFF3F3F3))),
                )
            ),
            Container(
                padding: EdgeInsets.fromLTRB(12,20,12,20),
                width: double.infinity,
                child: isBenefits?memberBenefits(benefits):rewardsForLevelUp(benefits)
            )
          ],
        )
    );
  }

  //会员权益
  Widget memberBenefits(benefits){
    return GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 0.0,
            crossAxisSpacing:2.0,
            childAspectRatio: 1.0
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: bloc.levels[bloc.currentLevel]["rights"].length,
        itemBuilder: this._getGridData

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
            Text(bloc.levels[bloc.currentLevel]["rights"][index]['label'],style: TextStyle(fontSize: 14),)
          ]
      ),
      // onTap: ()=>bloc.chooseServices(index),
    );
  }

  Widget _getReward(content,index){
    return GestureDetector(
      child: Container(
        child: ListTile(
          leading: Image.asset('assets/home_y.png',fit: BoxFit.cover,width: 30.0,height: 30.0,),
          title: Text(bloc.rewards[index]['reward'],style: TextStyle(fontSize: 16.0)),
          trailing: bloc.rewards[index]['status']==1
              ? Text('已领取',style: TextStyle(fontSize: 16.0))
              :TextButton(
                    onPressed: ()=>{bloc.receive(index)},
                    child: Text('领取',style: TextStyle(fontSize: 16.0))
                ),
        ),
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide.none,
              left: BorderSide.none,
              right: BorderSide.none,
              bottom: index==bloc.rewards.length-1?BorderSide.none: BorderSide(width: 1.0,color: Colors.grey[300]),
            )
        ),
      ),
      // onTap: ()=>bloc.viewInfo(index),
    );
  }

  //升级礼包
  Widget rewardsForLevelUp(rewards){
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),//禁止滚动
      itemCount: bloc.rewards.length,
      itemBuilder: this._getReward,
    );
  }
}
