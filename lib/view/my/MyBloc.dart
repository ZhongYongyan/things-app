import 'package:app/base/api/AvatarApis.dart';
import 'package:app/base/api/MemberApis.dart';
import 'package:app/base/entity/Member.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Result.dart';
import 'package:app/store/module/Auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
class MyBloc extends BlocBase with LoggingMixin {
  MyBloc(BuildContext context, Store store) : super(context, store);
  String loading = "##loading##";
  static const loadingTag = "##loading##"; //表尾标记
  var words = <String>[loadingTag];
  var path = "";
  File images;
  List textList = [
    "-",
    "京东商城",
    "天猫商城",
    "版本更新",
    "语言选择",
    "官方声明",
    "APP使用说明",
    "插件"
  ];
  bool show = false;
  String text = "最新";
  double h = 0;
  String imgPath = "";
  void startup() {
    //retrieveData();
    log.info("我的");
    getUser();
  }
  void getUser() async {
    Result<Member> response =
    await MemberApis.getMember();
    bool code = response.success;
    if(!code) {
      log.info("个人信息请求出错",response.message);
    }
    setModel(() {
      path = response.data.avatar;
      textList = [
        response.data.phone,
        "京东商城",
        "天猫商城",
        "版本更新",
        "语言选择",
        "官方声明",
        "APP使用说明",
        "插件"
      ];
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
    String response =
    await AvatarApis.getUpload(image);
    if(response != "") {
      saveImages(response);
    } else {
      Fluttertoast.showToast(
          msg: "保存失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  void saveImages(String path) async {
    String response =
    await MemberApis.setAvatar(path);
    if(response == "err") {
      Fluttertoast.showToast(
          msg: "保存失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "保存成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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
    if (i == 1) {
      const url = 'https://www.jd.com';

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    if (i == 2) {
      const url = 'https://www.tmall.com';

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    log.info(i);
    //navigate.pushReplacementNamed('/homeCon');
  }

  void retrieveData() {
    Future.delayed(Duration(seconds: 0)).then((e) {
      words.insertAll(
          words.length - 1,
          //每次生成20个单词
          ["1", "2", "3", "4", "5", "6", "7"].map((e) => e).toList());
      setModel(() {});
//      setState(() {
//        //重新构建列表
//      });
    });
  }
}
