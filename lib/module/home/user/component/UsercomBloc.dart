import 'package:app/packages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:image_picker/image_picker.dart';

class UsercomBloc extends BlocBase with LoggingMixin {
  UsercomBloc(BuildContext context, Store store) : super(context, store);
  final TextEditingController usernameController =
      TextEditingController(text: '');
  final TextEditingController heightController =
      TextEditingController(text: '');
  final TextEditingController weightController =
      TextEditingController(text: '');
  String loading = "##loading##";
  static const loadingTag = "##loading##"; //表尾标记
  var words = <String>[loadingTag];
  List textList = ["修改头像", "姓名或昵称", "性别", "身高(cm)", "体重(kg)", "出生日期"];
  List userList = ["修改头像", "", "性别", "", "", "点击选择"];
  bool show = false;
  String text = "最新";
  String imgPath = "";

  void startup() {
    //retrieveData();
    log.info("w222222222222222");
  }

  void to(String t) {
    setModel(() {
      text = t;
    });
    //navigate.pushReplacementNamed('/homeCon');
  }

  void click(String i) {
    setModel(() {
      userList[5] = i.substring(0, 10);
    });
  }

  void userClick(String i) {
    setModel(() {
      userList[2] = i;
    });
  }

  /*拍照*/
  void takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setModel(() {
      imgPath = image.path;
    });
  }

  /*相册*/
  void openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setModel(() {
      imgPath = image.path;
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
}
