import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/entity/IwaMall.dart';
import 'package:app/base/util/noripple.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/module/lang/Lang.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class IwaMallPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<IwaMallPage> with AutomaticKeepAliveClientMixin{

  bool _loadShow=true;
  int _pageIndex=1;
  static const int _pageSize=4;
  List<Banners> banners=[];
  List<Items> goods=[];
  bool _fold =false;//快捷入口默认不展开
  bool _isOver=true;//页面数据是否已到底
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);//控制上拉加载显隐
  ScrollController scrollController=ScrollController();
  @override
  void initState(){
    scrollController.addListener(() {
      if(scrollController.position.pixels==scrollController.position.maxScrollExtent){//表示触底
        if(_isOver){
          showToast('已经到底了');
        }else{
          _pageIndex++;
          loading.value=true;
          _getHomeData(_pageIndex);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _pageBody(context);
  }

  _pageBody(context) {
    if(_loadShow){
      _getHomeData(1);
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
      key: scaffoldKey,
      backgroundColor: Color(0xFFf8f8f8),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
                scrollBehavior: MyBehavior(),
                controller:scrollController,
                slivers:[
                  SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        // width: double.infinity,
                        child: AspectRatio(
                            aspectRatio: 12/5,
                            child: Swiper(
                              itemBuilder: ( context, int index) {
                                return GestureDetector(
                                  child: ClipRRect(
                                    borderRadius:BorderRadius.circular(10.0),
                                    child: Image.network(banners[index].pic,fit: BoxFit.cover),
                                    // child: Image.network(bloc.banners[index]['pic'],fit: BoxFit.cover),
                                  ),
                                  onTap: ()=>{

                                  },
                                );
                              },
                              autoplay: true,
                              duration: 500,
                              autoplayDelay: 3000,
                              itemCount: banners.length,
                              pagination: SwiperPagination(
                                  builder:DotSwiperPaginationBuilder(
                                      activeColor: Colors.white,
                                      color: Color.fromRGBO(169, 154, 142, 0.6)
                                  )
                              ),
                            )
                        ),
                      )
                  ),
                  SliverToBoxAdapter(
                      child: GridView.builder(
                          padding: EdgeInsets.all(10),
                          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing:10.0,
                              childAspectRatio: 0.6
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: goods.length,
                          itemBuilder: this._getGoodsData
                      )
                  ),
                  // SliverToBoxAdapter(
                  //     child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                  //       _gridReloadSetter = setState;
                  //       return GridView.builder(
                  //           padding: EdgeInsets.all(10),
                  //           gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  //               crossAxisCount: 2,
                  //               mainAxisSpacing: 10.0,
                  //               crossAxisSpacing:10.0,
                  //               childAspectRatio: 0.6
                  //           ),
                  //           shrinkWrap: true,
                  //           physics: NeverScrollableScrollPhysics(),
                  //           itemCount: goods.length,
                  //           itemBuilder: this._getGoodsData
                  //       );
                  //     })
                  // ),
                  SliverToBoxAdapter(
                    child: ValueListenableBuilder<bool>(
                      builder: _buildWithValue,
                      valueListenable: loading,
                    ),
                  )
                ]
            ),
            Positioned(
              right: 30,
              bottom: 50,
              child: _fold?
                  Column(
                    children: [
                      _floatButton(Icons.assignment_outlined,_toOrderPage,'order'),
                      SizedBox(height: 5),
                      _floatButton(Icons.close_rounded,_unfold,'fold')
                    ],
                  )
              :_floatButton(Icons.person_outline_rounded,_unfold,'unfold'),
            )
          ],
        )
      ),
    );
  }

  Widget _buildWithValue(BuildContext context, bool value, Widget child) {
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: Opacity(
            opacity: value?1:0,
            child: CircularProgressIndicator(color: Colors.grey[300]),
          ),
        ),
      ),
    );
  }

  //获取商品
  Widget _getGoodsData(content,index) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        child:GestureDetector(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          image: DecorationImage(
                              image: NetworkImage(goods[index].pic),
                              fit: BoxFit.contain
                          )
                      ),
                    ),
                  ),
                  // child: Image.network(bloc.goods[index]["pic"],fit:BoxFit.cover,width: double.infinity,),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getText(goods[index].name,17.0,Colors.black),
                      getText(goods[index].label,13.0,Colors.grey),
                      getText('销量:${goods[index].saleNum}',13.0,Colors.grey),
                      Row(
                        children: [
                          Image.network('https://ce.irestapp.com/order/frontend/web/images/point-on.png',fit: BoxFit.cover,width: 18),
                          SizedBox(width: 5),
                          getText("${goods[index].pointPrice}",17.0,Colors.red),
                        ],
                      )
                    ],
                  ),
                )
              ],
          ),
          onTap: ()=>Navigator.of(context).pushNamed('/goodsDetail',arguments: {"mid":goods[index].mid})//前往商品详情页
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

  //浮动按钮
  Widget _floatButton(IconData icon,Function func,String tag){
    return FloatingActionButton(
      elevation:0,
      backgroundColor: Colors.black.withOpacity(0.5),
      child: Icon(icon,size: 30),
      heroTag: tag,
      onPressed: ()=>func(),
    );
  }

  @override
  bool get wantKeepAlive => true;

  //获取首页轮播图
  void _getHomeData(index) async {
    IwaResult<IwaMall> response = await IwaMallApis.getHomeData(index,_pageSize);
    print(response);
    bool code = response.success;
    var goodsTemp = response.data.items;
    bool isOver=response.data.ending;
    Future.delayed(Duration(microseconds: 200)).then((e) {
      loading.value=false;
      if(_pageIndex==1){
        var tempBanner=response.data.banner;
        // banners.insertAll(0, tempBanner.map((item) => item));
        if(tempBanner.isNotEmpty){
          banners.addAll(tempBanner);
        }
        _loadShow=false;
      }
      if(goodsTemp.isNotEmpty){
        goods.addAll(goodsTemp);
      }
      setState((){
        _isOver=isOver;
      });
    });
  }

  //展开快捷入口，显示订单和购物车
  void _unfold(){
    setState(() {
      _fold=!_fold;
    });
  }

  //前往订单列表页
  void _toOrderPage(){
    Navigator.of(context)..pushNamed('/orders');
  }

}
