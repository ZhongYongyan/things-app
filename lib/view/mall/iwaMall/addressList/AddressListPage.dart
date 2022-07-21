import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/noripple.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

import '../IwaMallBloc.dart';
import 'AddressListBloc.dart';
class AddressListPage extends StatefulWidget {
  // const AddressListPage({Key? key}) : super(key: key);

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends BlocState<AddressListPage,AddressListBloc> {
  @override
  AddressListBloc createBloc(Store<StoreState> store) {
    return AddressListBloc(context, store);
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

  _pageBody(){
    if(bloc.loadShow){
      bloc.getAddressList();
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
        // actions:[
        //   Center(
        //     child: GestureDetector(
        //       child: Container(
        //         width: 60,
        //         alignment: Alignment.center,
        //         margin: EdgeInsets.all(10),
        //         decoration: BoxDecoration(
        //             color: Color(0xFFE94F1C),
        //             borderRadius: BorderRadius.circular(10)
        //         ),
        //         child: Text('新增地址'),
        //       ),
        //       onTap: ()=>bloc.toAddAddress(),
        //     ),
        //   )
        // ],
      ),
      body:
      Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 70),
            height: double.infinity,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: bloc.myAddress.length,
                itemBuilder: this._getInfoData,
              ),
            )
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 70,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(0xFFE94F1C),
                    borderRadius: BorderRadius.circular(50)
                ),
                padding: EdgeInsets.all(10),
                child: Text(bloc.addAddress,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w700
                    )
                ),
              ),
              onTap: ()=>bloc.toAddAddress()
            ),
          )
        ],
      ),
    );
  }

  Widget _getInfoData(content,index){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(top: 5,bottom: 5),
        child: ListTile(
          // leading: Image.asset('assets/home_y.png',fit: BoxFit.cover,width: 30.0,height: 30.0,),
          title: Row(
            children: [
              bloc.myAddress[index].isDefault
                  ?Container(
                    padding: EdgeInsets.only(left: 5,right: 5),
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: Color(0xFFE94F1C),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(bloc.defaultAddress,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13
                      ),
                    ),
                  ):Container(),
              Text("${bloc.myAddress[index].name} ${bloc.myAddress[index].phone}",style: TextStyle(fontSize: 17))
            ],
          ),
          subtitle: Text("${bloc.myAddress[index].province} ${bloc.myAddress[index].city} ${bloc.myAddress[index].area} ${bloc.myAddress[index].street}",maxLines: 2,overflow: TextOverflow.ellipsis),
          trailing: IconButton(
            color: Colors.grey[300],
            icon: Icon(Icons.edit),
            onPressed: ()=>bloc.toEditAddress(index),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide.none,
              left: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide(width: 1.0,color: Colors.grey[100]),
            )
        ),
      ),
      onTap: ()=>bloc.chooseAddress(index),
      onLongPress:()=>_showDeleteDialog(index)
    );
  }

  //弹窗删除
  _showDeleteDialog(index){
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context){
          return Container(
            height: 120,
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    height: 55,
                    alignment: Alignment.center,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(bloc.delete,style: TextStyle(color: Colors.red,fontSize: 16)),
                  ),
                  onTap: ()=>{
                    Navigator.pop(context),
                    bloc.deleteAddress(index)
                  },
                ),
                GestureDetector(
                  child: Container(
                    height: 55,
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(bloc.cancel,style: TextStyle(color: Colors.black,fontSize: 16)),
                  ),
                  onTap: ()=>Navigator.pop(context),
                )
              ],
            ),
          );
        }
    );
  }

}
