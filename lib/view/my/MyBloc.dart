import 'package:app/base/api/AvatarApis.dart';
import 'package:app/base/api/MemberApis.dart';
import 'package:app/base/entity/AppUpdate.dart';
import 'package:app/base/entity/Member.dart';
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
  var path = "";
  File images;
  List textList = [];
  bool show = false;
  String text = "最新";
  double h = 0;
  String imgPath = "";
  int versionCode = 13;

  void startup() {
//    retrieveData();
    textList = [
      "-",
      // state.lang.localized(Langs.jdMall),
      state.lang.localized(Langs.tmMall),
      state.lang.localized(Langs.edition),
      state.lang.localized(Langs.language),
      state.lang.localized(Langs.statement),
      state.lang.localized(Langs.explain),
      state.lang.localized(Langs.wifiConfig),
    ];
    getUser();
  }

  void getUser() async {
    Result<Member> response = await MemberApis.getMember();
    bool code = response.success;
    if (!code) {
      log.info("个人信息请求出错", response.message);
    }
    setModel(() {
      path = response.data.avatar;
      textList[0] = response.data.phone;
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

  void click(int i) async {
    // if (i == 1) {
    //   const url = 'https://mall.jd.com/index-1000282321.html?';
    //
    //   if (await canLaunch(url)) {
    //     await launch(url);
    //   } else {
    //     throw 'Could not launch $url';
    //   }
    // }
    if (i == 1) {
      const url = 'https://irest.m.tmall.com/';

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    if (i == 2) {
      Result<AppUpdate> result = await AppUpdateApis.findAppUpdate(versionCode);
      if (result.name != "not_found") {
        if (Platform.isAndroid) {
          FlutterXUpdate.checkUpdate(url: "https://things.irest.cn/api/upload/appUpdate", supportBackgroundUpdate: true);
        }else {
          // await launch('https://www.pgyer.com/igvR');
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
    }
    if (i == 3) {
      languageSettings();
    }

    if (i == 6) {
      navigate.pushNamed('/wifi-connfig');
    }
    log.info(i);
    //navigate.pushReplacementNamed('/homeCon');
  }

  void retrieveData() {
    Future.delayed(Duration(seconds: 0)).then((e) {
      words.insertAll(
          words.length - 1,
          //每次生成20个单词
          ["1", "2", "3", "4", "5", "6", "7", "8"].map((e) => e).toList());
      setModel(() {});
//      setState(() {
//        //重新构建列表
//      });
    });
  }
}
