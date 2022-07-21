import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/noripple.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'GoodsDetailBloc.dart';

class GoodsDetailPage extends StatefulWidget {
  // const GoodsDetailPage({Key? key}) : super(key: key);

  @override
  State<GoodsDetailPage> createState() => _GoodsDetailPageState();
}

class _GoodsDetailPageState extends BlocState<GoodsDetailPage,GoodsDetailBloc> {

  @override
  GoodsDetailBloc createBloc(Store<StoreState> store) {
    return GoodsDetailBloc(context, store);
  }

  @override
  Widget createWidget(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map;
    int mid = args["mid"];
    bloc.mid=mid;
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
        title: Text(bloc.goodsDetailLabel,
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
                      child: Container(
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return Image.network(bloc.banners[index],fit: BoxFit.scaleDown);
                              },
                              autoplay: true,
                              duration: 500,
                              autoplayDelay: 3000,
                              itemCount: bloc.banners.length,
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
                      child: Container(
                        // margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.network('https://ce.irestapp.com/order/frontend/web/images/point-on.png',fit: BoxFit.cover,width: 20),
                                    SizedBox(width: 5),
                                    getText("${bloc.goodsDetail[0].pointPrice}",20.0,Color(0xFFE94F1C))
                                  ],
                                ),
                                getText(bloc.saleNum+":${bloc.saleNumber}",15.0,Colors.grey),
                              ],
                            ),
                            SizedBox(height: 5),
                            getText(bloc.goodsDetail[0].name,20.0,Colors.black),
                          ],
                        ),
                      )
                  ),
                  SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 50,
                                child: Divider(height: 1.0,thickness:1.0,indent: 0.0,endIndent: 10.0,color: Color(0xFFE3E3E3)),
                              ),
                              Text(
                                bloc.goodsDetailLabel,
                                style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 16
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: Divider(height: 1.0,thickness:1.0,indent: 10.0,color: Color(0xFFE3E3E3)),
                              )
                            ],
                          ),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),//禁止滚动
                            itemCount: bloc.detailPics.length,
                            itemBuilder: this._getDetailPics,
                          )
                        ],
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
                  children: [
                    // Expanded(
                    //   flex: 1,
                    //   child: Container(
                    //     height: 42,
                    //     child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children:[
                    //           Container(
                    //             // padding: EdgeInsets.all(5.0),
                    //             child: Image.asset('assets/home_y.png',width: 20.0,height: 20.0,),
                    //           ),
                    //           Text(bloc.customerService,style: TextStyle(fontSize: 12),)
                    //         ]
                    //     ),
                    //   )
                    // ),
                    // Expanded(
                    //     flex: 1,
                    //     child: Container(
                    //       height: 42,
                    //       child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children:[
                    //             Container(
                    //               // padding: EdgeInsets.all(5.0),
                    //               child: Image.asset('assets/home_y.png',width: 20.0,height: 20.0,),
                    //             ),
                    //             Text(bloc.cart,style: TextStyle(fontSize: 12),)
                    //           ]
                    //       ),
                    //     )
                    // ),
                    // Expanded(
                    //   flex: 2,
                    //   child: GestureDetector(
                    //       child: Container(
                    //         height: 42,
                    //         margin: EdgeInsets.only(left: 5,right: 5),
                    //         decoration: BoxDecoration(
                    //             color: Color(0xFFFFA500),
                    //           borderRadius: BorderRadius.circular(50)
                    //         ),
                    //         child: Center(
                    //           child: Text(bloc.addToCart,
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //                 fontSize: 16
                    //             ),
                    //           ),
                    //         )
                    //       ),
                    //       onTap: (){
                    //         _modelBottom('cart');
                    //       }
                    //   ),
                    // ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                          child: Container(
                            height: 42,
                            margin: EdgeInsets.only(left: 5,right: 5),
                            decoration: BoxDecoration(
                                color: Color(0xFFE94F1C),
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: Center(
                              child: Text(bloc.buyNow,
                                  style: TextStyle(
                                      color: Colors.white,
                                    fontSize: 16
                                  ),
                              ),
                            ),
                          ),
                          onTap: (){
                            _modelBottom('now');
                          }
                      ),
                    ),

                  ],
                ),
              )
            )
          ],
        )
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


  //详情图片
  Widget _getDetailPics(content,index){
    return Image.network(bloc.detailPics[index],fit: BoxFit.cover);
  }

  /*
  * 颜色标签
  * */
  List<Widget> _labels(item,state){
    //map后面要写Widget，不然会报list<dynamic> is not a subtype of type list<Widget>
    var tempList=item.asMap().entries.map<Widget>((e){
      return ChoiceChip(
        padding: EdgeInsets.zero,
        backgroundColor:Color(0xFFEEEEEE),
        side: BorderSide(
          color: bloc.productIndex==e.key ?Color(0xFFE94F1C): Color(0xFFEEEEEE),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
        labelPadding: EdgeInsets.all(0),
        selected: bloc.productIndex==e.key,
        onSelected: (isSelected) {
          state((){
            bloc.productIndex=e.key;
          });
          // bloc.setModalBottomSheetState(e.key);
        },
        selectedColor: Colors.white,
        label: Container(
          padding: EdgeInsets.fromLTRB(15,5,15,5),
          // constraints: BoxConstraints(minWidth: bloc.labelsWidth),
          child: Text(e.value.color,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: bloc.productIndex==e.key ? Color(0xFFE94F1C) : Colors.black,
            ),
          ),
        ),
      );
    });
    return tempList.toList();
  }

  //弹出层，显示商品规格
  void _modelBottom(String kind){
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context1,state){
              return Container(
                height: 600,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: ()=>Navigator.pop(context1),
                          icon: Icon(Icons.close)
                      ),
                    ),
                    Align(
                      alignment:Alignment(-1,-1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: [
                              Image.network(bloc.goodsDetail[bloc.productIndex].img,fit: BoxFit.cover,width: 100,height: 80),
                              SizedBox(width: 5),
                              Image.network('https://ce.irestapp.com/order/frontend/web/images/point-on.png',fit: BoxFit.cover,width: 18,),
                              SizedBox(width: 5),
                              getText("${bloc.goodsDetail[bloc.productIndex].pointPrice}",18.0,Color(0xFFE94F1C))
                            ],
                          ),
                          Expanded(
                              child: ScrollConfiguration(
                                behavior: MyBehavior(),
                                child: ListView(
                                  padding: EdgeInsets.only(top:20,bottom: 60),
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        getText(bloc.colorLabel,16.0,Colors.black),
                                        Container(
                                            padding: EdgeInsets.fromLTRB(12,20,12,20),
                                            width: double.infinity,
                                            child: Wrap(
                                              spacing: 10,
                                              runSpacing: 10,
                                              children: _labels(bloc.goodsDetail,state),
                                            )
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        getText(bloc.qtyLabel,16.0,Colors.black),
                                        Container(
                                          child: Row(
                                            children: [
                                              _quantityEdit(
                                                  IconButton(
                                                      iconSize: 18,
                                                      // disabledColor: Colors.white70,
                                                      padding: EdgeInsets.all(0),
                                                      onPressed: (){
                                                        if(bloc.quantity>1){
                                                          state((){
                                                            bloc.quantity--;
                                                          });
                                                        }else{
                                                          bloc.overRange(bloc.minQuantityTip);
                                                        }
                                                      },
                                                      icon: Icon(Icons.remove)
                                                  )
                                              ),
                                              _quantityEdit(Text('${bloc.quantity}'),true),
                                              _quantityEdit(IconButton(
                                                  iconSize: 18,
                                                  padding: EdgeInsets.all(0),
                                                  onPressed: (){
                                                    if(bloc.quantity<999){
                                                      state((){
                                                        bloc.quantity++;
                                                      });
                                                    }else{
                                                      bloc.overRange(bloc.maxQuantityTip);
                                                    }
                                                  },
                                                  icon: Icon(Icons.add)
                                              )),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                          )

                        ],
                      ),
                    ),
                    Align(
                      alignment:Alignment.bottomLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFE94F1C),
                            minimumSize: Size(double.infinity, 46),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )
                        ),
                        child: getText(bloc.determine,18,Colors.white),
                        onPressed: (){
                          // Navigator.pop(context1);
                          bloc.confirmChoose(kind);
                        },
                      ),
                    )
                  ],
                ),
              );
            }
        );//showModalBottomSheet相当于打开一个新的页面，所以不可直接使用setData更新它里面的数据，需要包裹上StatefulBuilder并创建一个新的setData方法，即state
      },
    );
  }

  //数量编辑模块
  Widget _quantityEdit(Widget widget, [bool isNum=false]){
    return Container(
      width:36,
      height: 36,
      color:Color(0xFFEFEFEF),
      alignment: Alignment.center,
      margin: isNum?EdgeInsets.only(left: 2,right: 2):EdgeInsets.zero,
      child: widget
    );
  }
}
