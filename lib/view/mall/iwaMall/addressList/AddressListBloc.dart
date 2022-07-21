import 'dart:convert';
import 'dart:io';
import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/entity/IwaAddress.dart';
import 'package:app/base/entity/IwaMall.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
class AddressListBloc extends BlocBase with LoggingMixin {
  AddressListBloc(BuildContext context, Store store) : super(context, store);
  String get title => state.lang.localized(Langs.myAddress);
  String get defaultAddress => state.lang.localized(Langs.defaultAddress);
  String get delete => state.lang.localized(Langs.delete);
  String get cancel => state.lang.localized(Langs.cancel);
  String get addAddress => state.lang.localized(Langs.addAddress);
  bool loadShow=true;
  List<IwaAddress> myAddress;
  // List  myAddress = [
  //   {
  //     "id":1,
  //     "name":"张三",
  //     "phone":"13587962563",
  //     "province":"浙江省",
  //     "city":"嘉兴市",
  //     "area":"南湖区",
  //     "street":"浙江清华长三角研究院A幢1203",
  //     "isDefault":true,
  //   },
  //   {
  //     "id":2,
  //     "name":"李四",
  //     "phone":"13587962563",
  //     "region":"浙江省 嘉兴市 南湖区",
  //     "street":"浙江清华长三角研究院A幢1203",
  //     "isDefault":false,
  //   },
  //   {
  //     "id":3,
  //     "name":"马尔扎哈",
  //     "phone":"18587962563",
  //     "region":"内蒙古自治区 阿拉善盟 内蒙古阿拉善高新技术产业开发区",
  //     "street":"叽里呱啦吉林咖喱阿斯加德弗拉可接受的奥克斯大奖罚款了身份的埃里克森剪短发来看水电费",
  //     "isDefault":false,
  //   },
  //   {
  //     "id":2,
  //     "name":"李四",
  //     "phone":"13587962563",
  //     "region":"浙江省 嘉兴市 南湖区",
  //     "street":"浙江清华长三角研究院A幢1203",
  //     "isDefault":false,
  //   },
  //   {
  //     "id":3,
  //     "name":"马尔扎哈",
  //     "phone":"18587962563",
  //     "region":"内蒙古自治区 阿拉善盟 内蒙古阿拉善高新技术产业开发区",
  //     "street":"叽里呱啦吉林咖喱阿斯加德弗拉可接受的奥克斯大奖罚款了身份的埃里克森剪短发来看水电费",
  //     "isDefault":false,
  //   }
  // ];
  // List<IwaAddress> myAddress;
  // myAddress=myAddressTemp.map((item) => IwaAddress.fromJson(item)).toList() ?? [];

  //获取用户地址列表
  void getAddressList() async {
    IwaResult<IwaFormat> response = await IwaMallApis.getAddressList('13957370521');
    print(response);
    myAddress = response.data.errMsg;
    Future.delayed(Duration(microseconds: 200)).then((e) {
      setModel(() {
        myAddress = myAddress;
        loadShow=false;
      });
    });
  }

  //选择地址
  void chooseAddress(int index){
    navigate.pop(myAddress[index]);
  }
  //去编辑地址
  void toEditAddress(int index){
    print(myAddress[index].isDefault);
    navigate.pushNamed('/addressEdit',arguments: {"info":myAddress[index]}).then((info){
      print('back');
      print(info);
      //获取标签页面用户选择的标签并渲染页面
      if(info != null ){
        setModel(() {
          loadShow=true;
        });
        getAddressList();//重新获取地址列表
      }
    });
  }

  //去新增地址
  void toAddAddress(){
    navigate.pushNamed('/addressEdit').then((info){
      //获取标签页面用户选择的标签并渲染页面
      if(info != null ){
        setModel(() {
          loadShow=true;
        });
        getAddressList();//重新获取地址列表
      }
    });
  }

  //删除地址
  void deleteAddress(int index) async{
    String response = await IwaMallApis.deleteAddress('13957370521', myAddress[index].id);
    if(response != 'err' && response != 'null'){
      myAddress.removeAt(index);
      setModel(() {
        myAddress=myAddress;
      });
      showToast('删除成功');
    }else{
      showToast('删除失败');
    }
  }
}