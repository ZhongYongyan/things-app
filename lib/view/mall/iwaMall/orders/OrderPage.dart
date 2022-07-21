import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/noripple.dart';
import 'package:app/store/Store.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

import 'orderItem/OrderItemPage.dart';

class OrderPage extends StatefulWidget {
  // const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

// class _OrderPageState extends BlocState<OrderPage,OrderBloc> with TickerProviderStateMixin{
//
//   @override
//   void initState(){
//     super.initState();
//   }
//
//   @override
//   OrderBloc createBloc(Store<StoreState> store) {
//     return OrderBloc(context, store,TabController(length: 4, vsync: this));
//   }
//
//   @override
//   Widget createWidget(BuildContext context) {
//     super.build(context);
//     bloc.initLabels();
//     Widget body = _pageBody();
//     return body;
//   }
//
//   _pageBody(){
//     return Scaffold(
//       key: bloc.scaffoldKey,
//       appBar: AppBar(
//         elevation: 0,
//         title: Text(bloc.title,style: TextStyle(color: Colors.black)),
//         bottom: TabBar(
//           // indicatorSize: TabBarIndicatorSize.label,
//           labelColor: Colors.black,
//           labelPadding: EdgeInsets.zero,
//           indicatorColor: Color(0xFFE94F1C),
//           tabs: bloc.item.map((item) => Tab(
//             text: item,
//           )).toList(),
//           controller: bloc.tabController,
//           onTap: (index){
//             bloc.pageController?.jumpToPage(index);
//           },
//         ),
//         // toolbarTextStyle: TextStyle(fontSize: 30),
//       ),
//       body: Container(
//         color: Color(0xFFF9F9F9),
//         child:PageView.builder(
//             itemCount: 4,
//             onPageChanged: (index) {
//               if (bloc.isPageCanChanged) {//由于pageview切换是会回调这个方法,又会触发切换tabbar的操作,所以定义一个flag,控制pageview的回调
//                 bloc.tabController?.animateTo(index);
//               }
//             },
//             controller: bloc.pageController,
//             itemBuilder: (_,index)=>OrderItemPage(index)
//         ),
//       ),
//     );
//   }
// }

class _OrderPageState extends State<OrderPage> with AutomaticKeepAliveClientMixin{
  bool loadShow=true;
  bool isPageCanChanged=true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Tab> myTabs = <Tab>[
    Tab(text: '全部'),
    Tab(text: '待发货'),
    Tab(text: '待收货'),
    Tab(text: '已完成'),
  ];
  final List<Widget> myTabViews = <Widget>[
    OrderItemPage(0),
    OrderItemPage(1),
    OrderItemPage(2),
    OrderItemPage(3),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            elevation: 0,
            bottom: TabBar(
              tabs: myTabs,
              labelColor: Colors.black,
              // labelPadding: EdgeInsets.zero,
              indicatorColor: Color(0xFFE94F1C),
            ),
          ),
          body: TabBarView(
            children: myTabViews,
          ),
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}



