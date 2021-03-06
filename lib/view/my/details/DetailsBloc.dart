import 'dart:ffi';

import 'package:app/base/api/AffiliateApis.dart';
import 'package:app/base/api/AvatarApis.dart';
import 'package:app/base/api/MemberApis.dart';
import 'package:app/base/entity/Affiliate.dart';
import 'package:app/base/entity/MemberInfo.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'dart:io';

import '../../../../store/module/Auth.dart';

class MyDetailsBloc extends BlocBase with LoggingMixin {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var memberInfoModel = MemberInfo.fromJson({});
  String get userDetails => state.lang.localized(Langs.userDetails);

  String get userAdd => state.lang.localized(Langs.userAdd);

  String get userPhoto => state.lang.localized(Langs.userPhoto);

  String get userGender => state.lang.localized(Langs.userGender);

  String get userHeight => state.lang.localized(Langs.userHeight);

  String get userWeight => state.lang.localized(Langs.userWeight);

  String get userDetailsName => state.lang.localized(Langs.userDetailsName);

  String get userPhone => state.lang.localized(Langs.userPhone);

  String get userDetailsBirthday =>
      state.lang.localized(Langs.userDetailsBirthday);

  String get male => state.lang.localized(Langs.male);

  String get female => state.lang.localized(Langs.female);

  String get clickSelect => state.lang.localized(Langs.clickSelect);

  String get tipsSuccess => state.lang.localized(Langs.tipsSuccess);

  String get tipsFail => state.lang.localized(Langs.tipsFail);

  String get deleteSuccess => state.lang.localized(Langs.deleteSuccess);

  String get deleteFail => state.lang.localized(Langs.deleteFail);

  String get back => state.lang.localized(Langs.back);

  String get preservation => state.lang.localized(Langs.preservation);

  String get preservations => state.lang.localized(Langs.preservations);

  String get delete => state.lang.localized(Langs.delete);

  String get deletes => state.lang.localized(Langs.deletes);

  String get cancel => state.lang.localized(Langs.cancel);

  String get determine => state.lang.localized(Langs.determine);

  String get camera => state.lang.localized(Langs.camera);

  String get album => state.lang.localized(Langs.album);

  String get confirmDeletion => state.lang.localized(Langs.confirmDeletion);

  String get confirmDeletionTips =>
      state.lang.localized(Langs.confirmDeletionTips);

  String get clickToFillIn => state.lang.localized(Langs.clickToFillIn);

  String get emptyNameEnd => state.lang.localized(Langs.emptyNameEnd);

  String get emptyName => state.lang.localized(Langs.emptyName);

  String get emptyGender => state.lang.localized(Langs.emptyGender);

  String get emptyHeight => state.lang.localized(Langs.emptyHeight);

  String get emptyWeight => state.lang.localized(Langs.emptyWeight);

  String get emptyBirthday => state.lang.localized(Langs.emptyBirthday);

  String get heightFormatError => state.lang.localized(Langs.heightFormatError);

  String get weightFormatError => state.lang.localized(Langs.weightFormatError);
  String get title => state.lang.localized(Langs.peCenter);
  String get facialRecognition => state.lang.localized(Langs.facialRecognition);
  String get labels => state.lang.localized(Langs.labels);
  bool show = false;
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController heightController = TextEditingController(text: '');
  TextEditingController weightController = TextEditingController(text: '');

  String loading = "##loading##";
  static const loadingTag = "##loading##"; //????????????
  var words = <String>[loadingTag];
  List textList = [];
  List userList = [];
  String text = "??????";
  String imgPath = "";
  String userImgPath = "";
  bool editShow = false;
  bool nameEmpty = false;
  bool loginProcessing = false;
  bool addAffiliateShow = false;
  var labelsWidth;
  File images;
  FocusNode usernameFocus = FocusNode();
  FocusNode heightFocus = FocusNode();
  FocusNode weightFocus = FocusNode();
  List rule=[
    [
      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]')),
      LengthLimitingTextInputFormatter(15)
    ],//???????????????????????????????????????????????????15?????????
    [
      // FilteringTextInputFormatter.allow(RegExp(r"^1([0-9])$")),
      LengthLimitingTextInputFormatter(3)
    ],//???????????????
    [
      // FilteringTextInputFormatter.allow(RegExp(r'(^\d{1,3}\.?\d{0,1})')),
      LengthLimitingTextInputFormatter(3)
    ]//????????????????????????
  ];//???????????????
  var userLabels=[];
  //????????????????????????????????????????????????
  MyDetailsBloc(BuildContext context, Store store) : super(context, store){
    usernameFocus.addListener(() {
      if(!usernameFocus.hasFocus){
        print(usernameController.text);
      }
    });
    heightFocus.addListener(() {
      if(!heightFocus.hasFocus){
        print('????????????1');
      }
    });
    weightFocus.addListener(() {
      if(!weightFocus.hasFocus){
        print('????????????2');
      }
    });
  }

  void to(String t) {
    setModel(() {
      text = t;
    });
  }

  //????????????????????????
  void getUserInfo() async{
    Result<MemberInfo> response = await MemberApis.getMemberInfo(1481305118212128);
    print(response.data);
  }

  // void dataClick(String i) {
  //   setModel(() {
  //     memberInfoModel.birthday = i.substring(0, 10);
  //   });
  // }

  void userClick(String i) {
    setModel(() {
      memberInfoModel.sex = i == 0 ? '0' : '1';//0?????????1??????
    });
  }

  void userClickHeight(String i) {
    setModel(() {
      memberInfoModel.height = int.parse(i);
    });
  }

  void weightClickHeight(String i) {
    setModel(() {
      memberInfoModel.weight = double.parse(i);
    });
  }

  /*??????*/
  void takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setModel(() {
      imgPath = image.path;
      images = image;
    });
  }

  /*??????*/
  void openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setModel(() {
      imgPath = image.path;
      images = image;
    });
  }

  void setUI() {
    textList = [
      userPhoto,
      userDetailsName,
      userPhone,
      facialRecognition,
      userGender,
      userHeight + "(cm)",
      userWeight + "(kg)",
      userDetailsBirthday,
      labels
    ];
    // userList = [userPhoto, "", "", clickSelect, "", "", clickSelect];
    // if (!editShow) {
    //   usernameController = TextEditingController(text: memberInfoModel.nickname);
    //   heightController = TextEditingController(
    //       text: memberInfoModel.height.toString() == "0"
    //           ? ""
    //           : memberInfoModel.height.toString());
    //   weightController = TextEditingController(
    //       text: memberInfoModel.weight.toString() == "0"
    //           ? ""
    //           : memberInfoModel.weight.toString());
    //   editShow = true;
    // }
    userList = [
      userPhoto,
      "",
      "18867674354",
      "?????????",
      memberInfoModel.sex == ""
          ? clickSelect
          : memberInfoModel.sex == "0" ? female : male,
      "",
      "",
      // memberInfoModel.birthday == ""
      //     ? clickSelect
      //     : memberInfoModel.birthday.substring(0, 10),
      "????????????"
    ];
    userImgPath = memberInfoModel.avatar;
    // print(memberInfoModel.birthday);
    getUserInfo();
  }

  void toBack() {
    navigate.pop();
  }

  void addAffiliate() async {
    addAffiliateShow = true;
    if (usernameController.text == "" || usernameController.text.length > 8) {
      if (usernameController.text.length > 8) {
        toast(emptyNameEnd);
        return;
      }
      toast(emptyName);
      return;
    }
    if (userList[3] == clickSelect) {
      toast(emptyGender);
      return;
    }

    if (heightController.text == "") {
      toast(emptyHeight);
      return;
    }
    try {
      print(int.parse(heightController.text).toString());
    } catch (e) {
      toast(heightFormatError);
      return;
    }
    if (weightController.text == "") {
      toast(emptyWeight);
      return;
    }
    try {
      print(double.parse(weightController.text).toString());
    } catch (e) {
      toast(weightFormatError);
      return;
    }
    if (userList[6] == clickSelect) {
      toast(emptyBirthday);
      return;
    }
    setModel(() {
      loginProcessing = true;
    });

    // var data = memberInfoModel.birthday.substring(0, 10);
    // memberInfoModel.birthday = data.replaceAll('-', '/');
    memberInfoModel.nickname = usernameController.text;
    memberInfoModel.weight = double.parse(weightController.text);
    memberInfoModel.height = int.parse(heightController.text);
    //???????????????
    if (imgPath == "") {
      saveAffiliate();
    } else {
      //???????????????
      String response = await AvatarApis.getUpload(images);
      setModel(() {
        memberInfoModel.avatar = response;
      });
      if (response != "") {
        saveAffiliate();
      } else {
        Fluttertoast.showToast(
            msg: tipsFail,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  void saveAffiliate() async {
    // Result<MemberInfo> response =
    // await MemberApis.modifyMemberInfo(memberInfoModel);
    // bool code = response.success;
    // setModel(() {
    //   loginProcessing = false;
    // });
    // if (code) {
    //   Fluttertoast.showToast(
    //       msg: tipsSuccess,
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //       timeInSecForIos: 1,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    //   navigate.pop();
    // } else {
    //   String message = response.message;
    //   Fluttertoast.showToast(
    //       msg: tipsFail,
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //       timeInSecForIos: 1,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    //   if (title == userDetails) {
    //     setModel(() {
    //       addAffiliateShow = false;
    //     });
    //   }
    // }
  }

  /*
  * ??????????????????????????????????????????15???????????????????????????????????????110~250cm??????????????????30~300kg
  * @value ??????????????????
  * @index ??????????????? 1???????????????5???????????????6????????????
  * */
  void submitInfo(String value, int index){
    if(index==1){
      print(index);
    }else if(index==5){
      print(index);
    }else if(index==6){
      print(index);
    }
  }

  void toast(String name) {
    Fluttertoast.showToast(
        msg: name,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  /*
  * ??????????????????
  * */
  void chooseLabels(){
    navigate.pushNamed("/labels").then((info){
      print(info);
      //??????????????????????????????????????????????????????
      setModel(() {
        userLabels=info;
      });
    });
  }

  @override
  void dispose(){
    super.dispose();
    usernameFocus.dispose();
    heightFocus.dispose();
    weightFocus.dispose();
  }
}