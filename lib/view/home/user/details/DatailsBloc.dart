import 'package:app/base/api/AffiliateApis.dart';
import 'package:app/base/api/AvatarApis.dart';
import 'package:app/base/entity/Affiliate.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'dart:io';

import '../../../../store/module/Auth.dart';

class DatailsBloc extends BlocBase with LoggingMixin {
  DatailsBloc(BuildContext context, Store store) : super(context, store);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var affiliateModel = Affiliate.fromJson({});
  String get userDetails => state.lang.localized(Langs.userDetails);
  String get userAdd => state.lang.localized(Langs.userAdd);
  String get portrait => state.lang.localized(Langs.portrait);
  String get userGender => state.lang.localized(Langs.userGender);
  String get userHeight => state.lang.localized(Langs.userHeight);
  String get userWeight => state.lang.localized(Langs.userWeight);
  String get userDetailsName => state.lang.localized(Langs.userDetailsName);
  String get userDetailsBirthday => state.lang.localized(Langs.userDetailsBirthday);
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
  String get confirmDeletionTips => state.lang.localized(Langs.confirmDeletionTips);
  String get clickToFillIn => state.lang.localized(Langs.clickToFillIn);

  String get emptyNameEnd => state.lang.localized(Langs.emptyNameEnd);
  String get emptyName => state.lang.localized(Langs.emptyName);
  String get emptyGender => state.lang.localized(Langs.emptyGender);
  String get emptyHeight => state.lang.localized(Langs.emptyHeight);
  String get emptyWeight => state.lang.localized(Langs.emptyWeight);
  String get emptyBirthday => state.lang.localized(Langs.emptyBirthday);
  String get heightFormatError => state.lang.localized(Langs.heightFormatError);
  String get weightFormatError => state.lang.localized(Langs.weightFormatError);
  String  title = "";
  bool show = false;
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController heightController = TextEditingController(text: '');
  TextEditingController weightController = TextEditingController(text: '');
  String loading = "##loading##";
  static const loadingTag = "##loading##"; //表尾标记
  var words = <String>[loadingTag];
  List textList = [];
  List userList = [];
  String text = "最新";
  String imgPath = "";
  String userImgPath = "";
  bool editShow = false;
  bool nameEmpty = false;
  bool loginProcessing = false;
  bool addAffiliateShow = false;
  File images;
  var heightPickerData =  [
    "110",
    "120",
    "130",
    "140",
    "150",
    "160",
    "170",
    "180",
    "190",
    "200",
    "210",
    "220",
    "230",
    "240",
    "250"
  ];
  var weightPickerData =  [
    "20",
    "30",
    "40",
    "50",
    "60",
    "70",
    "80",
    "90",
    "100",
    "110",
    "120",
    "130",
    "140",
    "150",
    "160",
    "170",
    "180",
    "190",
    "200",
    "210",
    "220",
    "230",
    "240",
    "250",
    "260",
    "270",
    "280",
    "290",
    "300"
    ];


  void startup() {
    //retrieveData();
  }

  void to(String t) {
    setModel(() {
      text = t;
    });
    //navigate.pushReplacementNamed('/homeCon');
  }

  void dataClick(String i) {
    setModel(() {
      affiliateModel.birthday = i.substring(0, 10);
    });
  }

  void userClick(String i) {
    setModel(() {
      affiliateModel.sex = i == female ? 'F' : 'M';
    });
  }

  void userClickHeight(String i) {
    setModel(() {
      affiliateModel.height = int.parse(i);
    });
  }

  void weightClickHeight(String i) {
    setModel(() {
      affiliateModel.weight = double.parse(i);
    });
  }

  /*拍照*/
  void takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setModel(() {
      imgPath = image.path;
      images = image;
    });
  }

  /*相册*/
  void openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setModel(() {
      imgPath = image.path;
      images = image;
    });
  }

  void retrieveData() {
    Future.delayed(Duration(seconds: 0)).then((e) {
      words.insertAll(
          words.length - 1,
          //每次生成20个单词
          ["1", "2", "3", "4", "5", "6"].map((e) => e).toList());
      setModel(() {});
//      setState(() {
//        //重新构建列表
//      });
    });
  }

  void setUI() {
    textList = [portrait, userDetailsName, userGender, userHeight + "(cm)", userWeight + "(kg)", userDetailsBirthday];
    userList = [portrait, "", clickSelect, "", "", clickSelect];
    title = userDetails;
    if (affiliateModel.id == 0) {
      title = userAdd;
    }
    if (!editShow) {
      usernameController = TextEditingController(text: affiliateModel.nickname);
      heightController = TextEditingController(text: affiliateModel.height.toString() == "0" ? "" : affiliateModel.height.toString());
      weightController = TextEditingController(text: affiliateModel.weight.toString() == "0.0" ? "" : affiliateModel.weight.toString());
      editShow = true;
    }
    userList = [
      portrait,
      "",
      affiliateModel.sex == "" ? clickSelect : affiliateModel.sex == "F" ? female : male,
      "",
      "",
      affiliateModel.birthday == ""
          ? clickSelect
          : affiliateModel.birthday.substring(0, 10)
    ];
    userImgPath = affiliateModel.avatar;
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
    if (userList[2] == clickSelect) {
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
    if (userList[5] == clickSelect) {
      toast(emptyBirthday);
      return;
    }
    setModel(() {
      loginProcessing = true;
    });

    var data = affiliateModel.birthday.substring(0, 10);
    affiliateModel.birthday = data.replaceAll('-', '/') + ' 23:23:23';
    affiliateModel.nickname = usernameController.text;
    affiliateModel.weight = double.parse(weightController.text);
    affiliateModel.height = int.parse(heightController.text);
    //未选择头像
    if (imgPath == "") {
      saveAffiliate();
    } else {
      //选择了头像
      String response = await AvatarApis.getUpload(images);
      setModel(() {
        affiliateModel.avatar = response;
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
    Result<Affiliate> response =
        await AffiliateApis.modifyAffiliate(affiliateModel);
    bool code = response.success;
    setModel(() {
      loginProcessing = false;
    });
    if (code) {
      Fluttertoast.showToast(
          msg: tipsSuccess,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      navigate.pop();
    } else {
      String message = response.message;
      Fluttertoast.showToast(
          msg: tipsFail,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      if (title == userDetails) {
        setModel(() {
          addAffiliateShow = false;
        });
      }
    }
  }

  void delAffiliate() async {
    addAffiliateShow = false;
    setModel(() {
      loginProcessing = true;
    });

    Result<Affiliate> response =
        await AffiliateApis.delAffiliate(affiliateModel);
    bool code = response.success;
    setModel(() {
      loginProcessing = false;
    });
    if (code) {
      Fluttertoast.showToast(
          msg: deleteSuccess,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      for (int i = 0; i < state.member.words.length; i++){
        if(state.member.words[i].id == affiliateModel.id) {
          state.member.words.removeAt(i);
          dispatch(authActions.user("访客"));
          dispatch(authActions.url(""));
          dispatch(authActions.affiliateId(0));
        }
      }
      navigate.pop();
    } else {
      Fluttertoast.showToast(
          msg: deleteFail,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
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
}
