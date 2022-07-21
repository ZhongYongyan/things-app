import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/noripple.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/mall/iwaMall/orderDetail/OrderDetailBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class OrderDetailPage extends StatefulWidget {
  // const OrderDetailPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends BlocState<OrderDetailPage, OrderDetailBloc> {

  @override
  OrderDetailBloc createBloc(Store<StoreState> store) {
    return OrderDetailBloc(context, store);
  }

  @override
  Widget createWidget(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map;
    bloc.goodsInfo=args["info"];
    Widget body = _pageBody();
    return body;
  }

  _pageBody(){
    if(bloc.loadShow){
      bloc.initLabels();
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
          title: Text(bloc.goodsInfo.status,style: TextStyle(color: Colors.black)),
        ),
        body: SafeArea(
            child:CustomScrollView(
              scrollBehavior: MyBehavior(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(Icons.location_pin,size: 30,color:Color(0xFFE94F1C)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 100),
                                        child: Text(bloc.userAddress.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 20,height: 1),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      getText(bloc.userAddress.phone, 20,1.2)
                                    ],
                                  ),
                                  getText("${bloc.userAddress.province} ${bloc.userAddress.city} ${bloc.userAddress.area} ${bloc.userAddress.street}", 16,1,Colors.grey)
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),//禁止滚动
                              itemCount: bloc.goodsInfo.details.length,
                              itemBuilder: this._getGoodsInfoData,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: getText("${bloc.accountPayable}",16,2)
                                    // child: getText("${bloc.goodsInfo['success']==1? bloc.disbursements:bloc.accountPayable}:",16,2)
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Image.network('https://ce.irestapp.com/order/frontend/web/images/point-on.png',fit: BoxFit.cover,width: 13),
                                          SizedBox(width: 2),
                                          getText('${bloc.goodsInfo.totalPoints}',16)
                                        ],
                                      )
                                  ),
                                )
                              ],
                            )
                          ],
                        )
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
                      itemCount: bloc.orderInfoLabel.length,
                      itemBuilder: this._getOrderInfoData,
                    ),
                  ),
                )
              ],
            )
        )
    );
  }

  //商品信息
  Widget _getGoodsInfoData(content,index){
    return Container(
      padding: EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Image.network(bloc.goodsInfo.details[index].img,fit: BoxFit.scaleDown,width: 80),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(bloc.goodsInfo.details[index].name,style: TextStyle(fontSize: 16),overflow: TextOverflow.ellipsis),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Image.network('https://ce.irestapp.com/order/frontend/web/images/point-on.png',fit: BoxFit.cover,width: 13),
                          SizedBox(width: 2),
                          getText('${bloc.goodsInfo.details[index].pointPrice}',16)
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getText(bloc.goodsInfo.details[index].label,14,1.5,Colors.grey[400]),
                    getText('x${bloc.goodsInfo.details[index].num}',14,1.5,Colors.grey[400]),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //订单信息
  Widget _getOrderInfoData(content,index){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: getText("${bloc.orderInfoLabel[index]}:",16,2)
        ),
        Expanded(
          flex: 3,
          child: Container(
              padding: EdgeInsets.only(left: 10),
              child: index==3 //备注
                  ? Text(bloc.orderInfoDetail[index],style: TextStyle(fontSize: 16,height: 1.2),)
                  :getText(bloc.orderInfoDetail[index], 16,2)
          ),
        )
      ],
    );
  }

  Widget getText(String text,double fs,[double height=1.5,Color color=Colors.black]) {
    return Text(text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: TextStyle(color: color, fontSize: fs, height: height));
  }
}

