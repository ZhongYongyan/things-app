import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/entity/IwaMall.dart';
import 'package:app/base/entity/IwaOrder.dart';
import 'package:app/base/util/noripple.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/view/mall/iwaMall/orders/receipt/ReceiptPage.dart';
import 'package:flutter/material.dart';

class OrderItemPage extends StatefulWidget {
  final int tabIndex;

  const OrderItemPage(this.tabIndex, {Key key});

  @override
  State<OrderItemPage> createState() => _OrderItemPageState();
}

// class _OrderItemPageState extends BlocState<OrderItemPage,OrderItemBloc> with AutomaticKeepAliveClientMixin{
//
//   @override
//   void initState(){
//     super.initState();
//   }
//
//   @override
//   OrderItemBloc createBloc(Store<StoreState> store) {
//     return OrderItemBloc(context, store);
//   }
//
//   @override
//   Widget createWidget(BuildContext context) {
//     super.build(context);
//     if(bloc.loadShow){
//       bloc.getOrderList(0);
//       return Container(
//           color: Colors.white,
//           alignment: Alignment.center,
//           child: SizedBox(
//               width: 24.0,
//               height: 24.0,
//               child: CircularProgressIndicator(strokeWidth: 2.0)
//           )
//       );
//     }
//     return Scaffold(
//       body: ScrollConfiguration(
//           behavior: MyBehavior(),
//           child: Container(
//             margin: EdgeInsets.all(10),
//             child: ListView.builder(
//               padding: EdgeInsets.zero,
//               shrinkWrap: true,
//               itemCount: bloc.orders.length,
//               itemBuilder: (content,index){
//                 return GestureDetector(
//                   child: Container(
//                     decoration:BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: Colors.white
//                     ),
//                     margin: EdgeInsets.only(bottom: 10),
//                     // padding: EdgeInsets.all(10),
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(10),
//                           margin: EdgeInsets.only(bottom: 10),
//                           decoration: BoxDecoration(
//                             border: Border(bottom: BorderSide(color:Colors.grey[200])),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(bloc.orders[index].sTime,style: TextStyle(fontSize: 16)),
//                               Text(bloc.orders[index].status,style: TextStyle(fontSize: 14,color: Color(0xFFE94F1C)))
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.all(10),
//                           child: Column(
//                             children: [
//                               _goodsList(index),
//                               _disbursements(index),
//                               // widget.tabIndex==2?ReceiptPage:Container()
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   onTap: (){
//                     bloc.toDetail(index);
//                   },
//                   // onTap: ()=>bloc.chooseAddress(index),
//                 );
//               },
//               controller: bloc.scrollController,
//             ),
//           )
//       )
//     );
//   }
//
//   Widget _goodsList(index){
//     return ListView.builder(
//         shrinkWrap: true,
//         itemCount: bloc.orders[index].details.length,
//         itemBuilder: (context1,inx){
//           return Container(
//             padding: EdgeInsets.only(bottom: 2),
//             child: Row(
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(right: 5),
//                   child: Image.network(bloc.orders[index].details[inx].img,fit: BoxFit.scaleDown,width: 80),
//                 ),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(bloc.orders[index].details[inx].name,style: TextStyle(fontSize: 16)),
//                           Container(
//                             child: Row(
//                               children: [
//                                 Image.network('https://ce.irestapp.com/order/frontend/web/images/point-on.png',fit: BoxFit.cover,width: 15),
//                                 SizedBox(width: 2),
//                                 Text('${bloc.orders[index].details[inx].pointPrice}',style: TextStyle(fontSize: 16))
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(bloc.orders[index].details[inx].label,style: TextStyle(color: Colors.grey[400],fontSize: 14)),
//                           Text('x${bloc.orders[index].details[inx].num}',style: TextStyle(color: Colors.grey[400],fontSize: 14))
//                         ],
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           );
//         }
//     );
//   }
//
//   Widget _disbursements(index){
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Text('${bloc.disbursements}:',style: TextStyle(fontSize: 16)),
//         Image.network('https://ce.irestapp.com/order/frontend/web/images/point-on.png',fit: BoxFit.cover,width: 15),
//         SizedBox(width: 2),
//         Text("${bloc.orders[index].totalPoints}",style: TextStyle(fontSize: 18))
//       ],
//     );
//   }
//
// }
class _OrderItemPageState extends State<OrderItemPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //表示触底
        print('over');
        if (_isOver) {
          showToast('已经到底了');
        } else {
          _pageNum++;
          getOrderList(phone, widget.tabIndex, _pageNum);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  bool _loadShow = true;
  static const int _pageSize = 5;
  int _pageNum = 1;
  bool _isOver = true; //表示当前页面数据是否全部加载完毕
  List _orders = [];
  String phone = '13957370521';
  final ValueNotifier<bool> receipt = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_orders.isEmpty) {
      if (_loadShow) {
        //加载中
        getOrderList(phone, widget.tabIndex, _pageNum);
        return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0)));
      } else {
        //暂无订单
        return Center(
            child: Text('暂无订单！',
                style: TextStyle(color: Colors.grey, fontSize: 20)));
      }
    }
    return Scaffold(
        key: ValueKey(widget.tabIndex),
        backgroundColor: Color(0xFFF8F8F8),
        body: ScrollConfiguration(
            behavior: MyBehavior(),
            child: Container(
              margin: EdgeInsets.all(10),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _orders.length + 1,
                controller: _scrollController,
                itemBuilder: (content, index) {
                  if (_orders.length == index && !_loadShow) {
                    return _isOver ? Container() : _buildProgressIndicator();
                  } else {
                    return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        margin: EdgeInsets.only(bottom: 10),
                        // padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[200])),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_orders[index].sTime,
                                      style: TextStyle(fontSize: 16)),
                                  Text(_orders[index].status,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFE94F1C)))
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  _goodsList(index),
                                  _disbursements(index),
                                  // ReceiptPage(_orders[index].cTime)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () => Navigator.of(context).pushNamed(
                          '/orderDetail',
                          arguments: {"info": _orders[index]}), //前往详情页
                    );
                  }
                },
              ),
            )));
  }

  //获取订单商品列表
  Widget _goodsList(index) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _orders[index].details.length,
        itemBuilder: (context1, inx) {
          return Container(
            padding: EdgeInsets.only(bottom: 2),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Image.network(_orders[index].details[inx].img,
                      fit: BoxFit.scaleDown, width: 80),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_orders[index].details[inx].name,
                              style: TextStyle(fontSize: 16)),
                          Container(
                            child: Row(
                              children: [
                                Image.network(
                                    'https://ce.irestapp.com/order/frontend/web/images/point-on.png',
                                    fit: BoxFit.cover,
                                    width: 15),
                                SizedBox(width: 2),
                                Text(
                                    '${_orders[index].details[inx].pointPrice}',
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_orders[index].details[inx].label,
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 14)),
                          Text('x${_orders[index].details[inx].num}',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 14))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  //交易失败订单显示应付款，交易成功订单显示实付款
  Widget _disbursements(index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(_orders[index].stage == 4 ? '应付款:' : '实付款:',
            style: TextStyle(fontSize: 16)),
        Image.network(
            'https://ce.irestapp.com/order/frontend/web/images/point-on.png',
            fit: BoxFit.cover,
            width: 15),
        SizedBox(width: 2),
        Text("${_orders[index].totalPoints}", style: TextStyle(fontSize: 18))
      ],
    );
  }

  //获取订单列表
  void getOrderList(String phone, int type, int index) async {
    IwaResult<IwaOrder> response =
        await IwaMallApis.getOrderList(phone, type, _pageSize, index);
    var orderTemp = response.data.items;
    bool isOver = response.data.over;
    Future.delayed(Duration(microseconds: 200)).then((e) {
      if (orderTemp.isNotEmpty) {
        _orders.addAll(orderTemp);
      }
      setState(() {
        _isOver = isOver;
        _loadShow = false;
      });
    });
  }

  //上拉加载动画
  Widget _buildProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(color: Colors.grey[300]),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
