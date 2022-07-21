import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/store/module/lang/Lang.dart';
import 'package:app/store/module/lang/Langs.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/view/mall/iwaMall/IwaMallPage.dart';
import 'package:redux/src/store.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'MallBloc.dart';

class MallPage extends StatefulWidget {
  // const MallPage({Key? key}) : super(key: key);

  @override
  _MallPageState createState() => _MallPageState();
}

// class _MallPageState extends BlocState<MallPage,MallBloc> with TickerProviderStateMixin{
//
//   @override
//   void initState(){
//     super.initState();
//     // bloc.tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   MallBloc createBloc(Store<StoreState> store) {
//     return MallBloc(context, store,TabController(length: 2, vsync: this))..setup();
//   }
//
//   @override
//   Widget createWidget(BuildContext context) {
//     super.build(context);
//     return _mallBody();
//   }
//
//   Widget _mallBody(){
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(55.0),
//         child: Container(
//           margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: NetworkImage('https://axhub.im/ax9/7daa3ef63e5c1293/images/商城/u0.png'),
//                   fit: BoxFit.fill
//               )
//           ),
//           child: _tabBar(),
//         ),
//       ),
//       body: _tabBarView(),
//     );
//   }
//
//   Widget _tabBar(){
//     return Container(
//       alignment: Alignment.topCenter,
//       padding: EdgeInsets.all(5),
//
//       child: Container(
//         padding: EdgeInsets.all(3),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(50),
//             color: Color(0xFFFEE9E8)
//         ),
//         child: PreferredSize(
//           preferredSize: Size(double.infinity, 30),
//           child: TabBar(
//             controller: bloc.tabController,
//             tabs: bloc.tabs.map((item) => Tab(
//               text: item,
//               iconMargin: EdgeInsets.zero,
//             )).toList(),
//             // indicatorSize:TabBarIndicatorSize.label ,
//             isScrollable: true,
//             unselectedLabelColor:Colors.redAccent,
//             indicatorSize: TabBarIndicatorSize.tab,
//             indicator:BoxDecoration(
//               gradient:LinearGradient(
//                 colors:[
//                   Colors.redAccent,
//                   Colors.orangeAccent,
//                 ],
//               ),
//               color:Colors.redAccent,
//               borderRadius:BorderRadius.circular(50),
//             ),
//             onTap: (index){
//               bloc.pageController?.jumpToPage(index);
//             },
//             // labelPadding: EdgeInsets.zero,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _tabBarView(){
//     return PageView(
//       onPageChanged: (index) {
//         if (bloc.isPageCanChanged) {//由于pageview切换是会回调这个方法,又会触发切换tabbar的操作,所以定义一个flag,控制pageview的回调
//           // bloc.onPageChange(index);
//           bloc.tabController?.animateTo(index);
//         }
//       },
//       controller: bloc.pageController,
//       children: [
//         WebView(
//           initialUrl: 'https://irest.m.tmall.com/',
//           javascriptMode: JavascriptMode.unrestricted,
//           onWebViewCreated: (WebViewController webViewController){
//           },
//         ),
//         IwaMallPage()
//       ],
//     );
//   }
//
// }


class _MallPageState extends State<MallPage> with AutomaticKeepAliveClientMixin{
  List tabs=[LangState().localized(Langs.tmMall),LangState().localized(Langs.pointStore)];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _tabBar(){
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color(0xFFFEE9E8)
        ),
        child: PreferredSize(
          preferredSize: Size(double.infinity, 30),
          child: TabBar(
            tabs: tabs.map((item) => Tab(
              text: item,
              iconMargin: EdgeInsets.zero,
            )).toList(),
            // indicatorSize:TabBarIndicatorSize.label ,
            isScrollable: true,
            unselectedLabelColor:Colors.redAccent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator:BoxDecoration(
              gradient:LinearGradient(
                colors:[
                  Colors.redAccent,
                  Colors.orangeAccent,
                ],
              ),
              color:Colors.redAccent,
              borderRadius:BorderRadius.circular(50),
            ),
            // labelPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          key: scaffoldKey,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(55.0),
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage('https://axhub.im/ax9/7daa3ef63e5c1293/images/商城/u0.png'),
                      fit: BoxFit.fill
                  )
              ),
              child: _tabBar(),
            ),
          ),
          body: TabBarView(
            children: [
              WebView(
                initialUrl: 'https://irest.m.tmall.com/',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController){
                },
              ),
              IwaMallPage()
            ],
          ),
        )
    );
  }

  @override
  bool get wantKeepAlive => true;

}


