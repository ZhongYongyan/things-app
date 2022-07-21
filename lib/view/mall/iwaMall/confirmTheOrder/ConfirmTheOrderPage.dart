import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/noripple.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/src/store.dart';

import 'ConfirmTheOrderBloc.dart';
class ConfirmTheOrderPage extends StatefulWidget {
  // const ConfirmTheOrder({Key? key}) : super(key: key);

  @override
  State<ConfirmTheOrderPage> createState() => _ConfirmTheOrderPageState();
}

class _ConfirmTheOrderPageState extends BlocState<ConfirmTheOrderPage,ConfirmTheOrderBloc> {

  @override
  void initState(){
    super.initState();
    // bloc.getPrePageData();
    // Future.delayed(Duration(milliseconds: 1000),(){
    //   dynamic arguments=ModalRoute.of(context).settings.arguments;
    //   print(arguments['goods']);
    //   print(777);
    //   bloc.goodsInfo=arguments['goods'];
    //
    // })
  }

  @override
  ConfirmTheOrderBloc createBloc(Store<StoreState> store) {
    return ConfirmTheOrderBloc(context, store);
  }

  @override
  Widget createWidget(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map;
    bloc.initPageData(args["goods"]);
    Widget body = _pageBody();
    return body;
  }

  _pageBody(){
    if(bloc.loadShow){
      bloc.getDetail();
      return Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(strokeWidth: 2.0)
          )
      );
    }
    return Scaffold(
      backgroundColor: Color(0xFFf8f8f8),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(bloc.confirmTheOrder,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
                scrollBehavior: MyBehavior(),
                slivers:[
                  SliverToBoxAdapter(
                      child: GestureDetector(
                        child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: bloc.iwaId==0?
                              Text(bloc.addressTip,
                                  style: TextStyle(
                                      fontSize: 20
                                  )
                              )
                              :Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 100),
                                    child: Text(bloc.userAddress.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 20
                                        )
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(bloc.userAddress.phone,
                                      style: TextStyle(
                                          fontSize: 20
                                      )
                                  )
                                ],
                              ),
                              subtitle: bloc.iwaId==0?null:Text("${bloc.userAddress.province} ${bloc.userAddress.city} ${bloc.userAddress.area} ${bloc.userAddress.street}",maxLines: 2,overflow: TextOverflow.ellipsis),
                              trailing: Icon(Icons.keyboard_arrow_right,size: 25),
                            )
                        ),
                        onTap: ()=>{
                          bloc.chooseAddress()
                        },
                      )
                  ),
                  SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),//禁止滚动
                          itemCount: bloc.goodsInfo.length,
                          itemBuilder: this._getGoodsInfoData,
                        )
                      )
                  ),
                  SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Text(bloc.remark),
                            ),
                            Expanded(
                                flex:1,
                                child: TextFormField(
                                  // controller: bloc.passwordController,
                                  // focusNode: bloc.passwordFocus,
                                  autocorrect: false,
                                  textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    // prefixText: "${bloc.remark}   ",
                                    // prefixStyle: TextStyle(
                                    //     fontSize: 16,
                                    //     color: Colors.black
                                    // ),
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: bloc.remarkPlaceholder,
                                    contentPadding: EdgeInsets.all(10.0),
                                    hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xFFcccccc)),
                                  ),
                                  inputFormatters:[LengthLimitingTextInputFormatter(100)],
                                  validator: (value) {
                                    if (value.isEmpty) {

                                    } else {

                                    }
                                  },
                                )
                            )
                          ],
                        ),
                      )
                  )
                ]
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 52,
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("${bloc.total}:",
                        style: TextStyle(
                            color: Color(0xFFE94F1C),
                            fontSize: 16
                        )
                      ),
                      Image.network('https://ce.irestapp.com/order/frontend/web/images/point-on.png',fit: BoxFit.cover,width: 18),
                      SizedBox(width: 3),
                      Text("${bloc.totalPrice}",
                          style: TextStyle(
                              color: Color(0xFFE94F1C),
                              fontSize: 20
                          )
                      ),
                      GestureDetector(
                          child: Container(
                            height: 42,
                            margin: EdgeInsets.only(left: 20,right: 5),
                            padding: EdgeInsets.only(left: 20,right: 20),
                            decoration: BoxDecoration(
                                color: Color(0xFFE94F1C),
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: Center(
                              child: Text(bloc.submitOrder,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16
                                ),
                              ),
                            ),
                          ),
                          onTap: (){
                              bloc.submitOrderHandler();
                          }
                      )

                    ],
                  ),
                )
            ),
            bloc.submitLoading?
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.grey.withOpacity(0.1),
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: Colors.red,
                          size: 50,
                        ),
                      ),
                    )
                ):
                Container()
          ],
        ),
      ),
    );
  }

  Widget getText(String text,double fs,Color color) {
    return Text(text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: TextStyle(color: color, fontSize: fs, height: 1.5));
  }

  Widget _getGoodsInfoData(content,index){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.network(bloc.goodsInfo[index].img,fit: BoxFit.cover,width: 100),
        Expanded(
          child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: getText(bloc.goodsInfo[index].name,18.0,Colors.black),
                    subtitle: getText(bloc.goodsInfo[index].color,14.0,Colors.grey),
                    contentPadding:EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
                      minVerticalPadding:0.1,
                      horizontalTitleGap:100.0
                      // visualDensity:VisualDensity(vertical: 0)
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.network('https://ce.irestapp.com/order/frontend/web/images/point-on.png',fit: BoxFit.cover,width: 20),
                          SizedBox(width: 2),
                          getText("${bloc.goodsInfo[index].pointPrice}",18.0,Color(0xFFE94F1C)),
                        ],
                      ),
                      getText("x${bloc.goodsInfo[index].quantity}",15.0,Colors.grey),
                    ],
                  )
                ],
              )
          ),
        ),

      ],
    );
  }
}
