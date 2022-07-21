import 'package:app/base/api/AvatarApis.dart';
import 'package:app/base/api/MemberApis.dart';
import 'package:app/base/entity/AppUpdate.dart';
import 'package:app/base/entity/Member.dart';
import 'package:app/base/entity/MemberInfo.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/Auth.dart';
import 'package:app/store/module/lang/Lang.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:app/view/home/user/component/ActionSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:app/base/api/AppUpdateApis.dart';

class MyBloc extends BlocBase with LoggingMixin {
  MyBloc(BuildContext context, Store store) : super(context, store);
  String loading = "##loading##";
  static const loadingTag = "##loading##"; //表尾标记
  var words = <String>[loadingTag];

  String get introduce => state.lang.localized(Langs.introduce);

  String get signOut => state.lang.localized(Langs.signOut);

  String get signOutTips => state.lang.localized(Langs.signOutTips);

  String get cancel => state.lang.localized(Langs.cancel);

  String get camera => state.lang.localized(Langs.camera);

  String get album => state.lang.localized(Langs.album);
  String get service => state.lang.localized(Langs.service);
  String get information => state.lang.localized(Langs.information);
  var path = "";
  File images;
  List myServices = [],myInfo=[];
  bool show = false;
  String text = "最新";
  double h = 0;
  String imgPath = "";
  int versionCode = 14;
  var memberInfo;
  void startup() {
//    retrieveData();
    myServices = [
      {
        "img":"",
        "title":state.lang.localized(Langs.myOrder),
        "id":"",
      },
      {
        "img":"",
        "title":state.lang.localized(Langs.healthRecord),
        "id":"healthArchive",
      },
      {
        "img":"",
        "title":state.lang.localized(Langs.buServices),
        "id":"",
      },
      {
        "img":"",
        "title":state.lang.localized(Langs.online),
        "id":"",
      },
      {
        "img":"",
        "title":state.lang.localized(Langs.signIn),
        "id":"signIn",
      },
      {
        "img":"",
        "title":state.lang.localized(Langs.language),
        "id":"lan",
      },
      {
        "img":"",
        "title":state.lang.localized(Langs.edition),
        "id":"version",
      }
    ];
    myInfo=[
      {
        "img":"",
        "title":state.lang.localized(Langs.peCenter),
        "id":"myDetails",
      },
      {
        "img":"",
        "title":state.lang.localized(Langs.statement),
        "id":"signIn",
      },
      {
        "img":"",
        "title":state.lang.localized(Langs.explain),
        "id":"lan",
      },
      {
        "img":"",
        "title":state.lang.localized(Langs.privacyAgreement),
        "id":"version",
      }
    ];
    getUser();
  }

  void getUser() async {
    Result<Member> response = await MemberApis.getMember();

    memberInfo=response.data;
    print(memberInfo);
    bool code = response.success;
    if (!code) {
      log.info("个人信息请求出错", response.message);
    }
    setModel(() {
      imgPath = response.data.avatar;
      // textList[0] = response.data.phone;
    });
  }

  /*拍照*/
  void takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setModel(() {
      imgPath = image.path;
    });
    edImages(image);
  }

  /*相册*/
  void openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setModel(() {
      imgPath = image.path;
    });
    edImages(image);
  }

  void edImages(File image) async {
    String response = await AvatarApis.getUpload(image);
    if (response != "") {
      saveImages(response);
    } else {
      Fluttertoast.showToast(
          msg: state.lang.localized(Langs.tipsFail),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void saveImages(String path) async {
    String response = await MemberApis.setAvatar(path);
    if (response == "err") {
      Fluttertoast.showToast(
          msg: state.lang.localized(Langs.tipsFail),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: state.lang.localized(Langs.tipsSuccess),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void languageSettings() {
    BottomActionSheet.show(context, ['中文', 'English'],
        title: '', cancel: cancel, callBack: (i) {
      if (i == 0) {
        dispatch(langActions.setup('cn'));
      }
      if (i == 1) {
        dispatch(langActions.setup('en'));
      }
    });
  }

  void signout() {
    dispatch(authActions.logout());
    navigate.pushReplacementNamed('/login');
  }

  void to(String t) {
    setModel(() {
      text = t;
    });
    log.info(text);
    //navigate.pushReplacementNamed('/homeCon');
  }

  //选择用户服务
  void chooseServices(int i) async {
    if(myServices[i]['id']=='version'){//版本更新
      Result<AppUpdate> result = await AppUpdateApis.findAppUpdate(versionCode);
      if (result.name != "not_found") {
        if (Platform.isAndroid) {
          FlutterXUpdate.checkUpdate(url: "192.168.1.114:11305/api/upload/appUpdate", supportBackgroundUpdate: true);
        }else {
          Fluttertoast.showToast(
              msg: state.lang.localized(Langs.noUpdatedVersion),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }else {
        Fluttertoast.showToast(
            msg: state.lang.localized(Langs.latestVersion),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 2,
            textColor: Colors.white,
            fontSize: 36.0);
      }
    }else if(myServices[i]['id']=='lan'){//语言切换
      languageSettings();
    }else{//跳转页面
      print(myServices[i]['id']);
      navigate.pushNamed("/${myServices[i]['id']}");
      // navigate.pushNamed("/signIn");
    }
    log.info(i);
  }

  //查看用户个人信息
  void viewInfo(int i){
    print(memberInfo);
    // navigate.pushNamed("/${myInfo[i]['id']}",arguments: {'model':MemberInfo.fromJson({})});
    navigate.pushNamed("/${myInfo[i]['id']}");
  }

  //跳转会员权益
  void memberBenefits(){
    navigate.pushNamed("/memberRights",arguments: {'id':state.user.id});
  }
//   void retrieveData() {
//     Future.delayed(Duration(seconds: 0)).then((e) {
//       words.insertAll(
//           words.length - 1,
//           //每次生成20个单词
//           ["1", "2", "3", "4"].map((e) => e).toList());
//       setModel(() {});
// //      setState(() {
// //        //重新构建列表
// //      });
//     });
//   }
}
