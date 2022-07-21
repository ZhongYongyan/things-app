import 'dart:convert' as convert;
import 'dart:io';
import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/entity/IwaAddress.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
class AddressEditBloc extends BlocBase with LoggingMixin {
  //监听输入框失去焦点时提交用户输入
  AddressEditBloc(BuildContext context, Store store) : super(context, store){
    usernameFocus.addListener(() {
      if(!usernameFocus.hasFocus){
        print(usernameController.text);
      }else{
        print('usernameFocus');
      }
    });
    phoneFocus.addListener(() {
      if(!phoneFocus.hasFocus){
        // print('phoneFocus');
      }else{
        print('phoneFocus');
      }
    });
    streetFocus.addListener(() {
      if(!streetFocus.hasFocus){
        // print('streetFocus');
      }else{
        print('streetFocus');
      }
    });
  }
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String get emptyName => state.lang.localized(Langs.emptyName);
  String get emptyPhone => state.lang.localized(Langs.emptyPhone);
  String get emptyRegion => state.lang.localized(Langs.emptyRegion);
  String get emptyStreet => state.lang.localized(Langs.emptyStreet);
  String get preservation=> state.lang.localized(Langs.preservation);
  String get errPhone=> state.lang.localized(Langs.errorPhoneNumber);
  bool submitLoading=false;//是否提交中
  List addressLabels=['收货人','手机号码','地区信息','详细地址','默认地址'];
  List labelsPlaceholder=['姓名','手机号码','地区信息','街道信息','是否选为默认地址'];
  String initProvince = '北京市', initCity = '市辖区', initTown = '东城区';
  int uid=1;//积分商城用户id
  var addressInfoModel = IwaAddress.fromJson({});
  String get title1=> state.lang.localized(Langs.addAddress);
  String get title2=> state.lang.localized(Langs.editAddress);
  String get editFail=> state.lang.localized(Langs.editFail);
  String get addFail=> state.lang.localized(Langs.addFail);
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController phoneController = TextEditingController(text: '');
  TextEditingController streetController = TextEditingController(text: '');

  FocusNode usernameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode streetFocus = FocusNode();

  List rule=[
    [
      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]')),
      LengthLimitingTextInputFormatter(15)
    ],//昵称仅限中文，英文字母和数字组成的15位字符
    [
      LengthLimitingTextInputFormatter(11)
    ],//手机号
    [
      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]')),
      LengthLimitingTextInputFormatter(100)
    ]//街道信息
  ];//输入框正则

  //初始化相关数据
  void initData(addressInfo){
    print(addressInfo);
    IwaAddress temp = IwaAddress.parseJson(convert.jsonEncode(addressInfo));//对象数据需要深拷贝，不然数据修改后即使不提交也会修改源数据
    setModel(() {
      addressInfoModel=temp;
      initProvince=addressInfo.province;
      initCity=addressInfo.city;
      initTown=addressInfo.area;
    });
    print(addressInfoModel.phone);
    usernameController = TextEditingController(text: addressInfoModel.name);
    phoneController = TextEditingController(text: addressInfoModel.phone);
    streetController = TextEditingController(text: addressInfoModel.street);
  }

  bool isChinaPhoneLegal(String str) {
    return RegExp(r"^1[3-9]\d{9}$").hasMatch(str);
  }

  //选择地区
  void addressRegion(String p,String c,String t) {
    if(p=='台湾省' || p=='香港特别行政区' || p=='澳门特别行政区'){
      showToast('暂不支持该地区');
      return;
    }
    setModel(() {
      addressInfoModel.province = p;
      addressInfoModel.city = c;
      addressInfoModel.area = t;
    });
  }

  void defaultAddress(bool i) {
    setModel(() {
      addressInfoModel.isDefault = i;
    });
  }

  //将输入框的值赋给addressInfoModel，用于提交表单
  void valueChange(int index, String val){
    switch(index){
      case 0:
        addressInfoModel.name=val;
        break;
      case 1:
        addressInfoModel.phone=val;
        break;
      // case 2:
      //   addressInfoModel.region=val;
      //   break;
      case 3:
        addressInfoModel.street=val;
        break;
      default:
        break;
    }
  }

  //编辑地址提交
  void editAddress() async{
    if(submitLoading) return;
    if(!formKey.currentState.validate()) return;
    String msg='';
    if(addressInfoModel.name==''){
      msg=emptyName;
    }else if(addressInfoModel.phone==''){
      msg=emptyPhone;
    }else if(!isChinaPhoneLegal(addressInfoModel.phone)){
      msg=errPhone;
    }else if(addressInfoModel.province=='' || addressInfoModel.city==''){
      msg=emptyRegion;
    }else if(addressInfoModel.street==''){
      msg=emptyStreet;
    }
    if(msg != ''){
      showToast(msg);
      return;
    }
    setModel(() {
      submitLoading = true;
    });
    print(addressInfoModel.isDefault);
    // if(addressInfoModel.area==''){
    //   addressInfoModel.area=addressInfoModel.city;
    //   addressInfoModel.city=addressInfoModel.province;
    // }
    String response;
    String errMsg;
    print(addressInfoModel.id);
    if(addressInfoModel.id==0){//新增地址
       // response = await IwaMallApis.addAddress(state.user.phone,addressInfoModel);
       response = await IwaMallApis.addAddress('13957370521', addressInfoModel);
       errMsg=addFail;
    }else{//编辑地址
      // response = await IwaMallApis.editAddress(state.user.phone, addressInfoModel);
      response = await IwaMallApis.editAddress('13957370521', addressInfoModel);
      errMsg=editFail;
    }
    print("response:"+response);
    if(response != null && response != 'null'){
      navigate.pop(true);
    }else{
      showToast(errMsg);
    }
    setModel(() {
      submitLoading = false;
    });
  }

  @override
  void dispose(){
    super.dispose();
    usernameFocus.dispose();
    phoneFocus.dispose();
    streetFocus.dispose();
  }
}