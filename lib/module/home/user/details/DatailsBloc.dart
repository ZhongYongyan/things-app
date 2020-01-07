import 'package:app/base/api/AffiliateApis.dart';
import 'package:app/base/entity/Affiliate.dart';
import 'package:app/packages.dart';
import 'package:app/util/Page.dart';
import 'package:app/util/Result.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

class DatailsBloc extends BlocBase with LoggingMixin {
  DatailsBloc(BuildContext context, Store store) : super(context, store);
  var affiliateModel = Affiliate.fromJson({});

  var list = [
    "基本信息",
    "睡眠情况",
    "血压",
    "心率",
    "情绪",
    "血流",
    "呼吸",
  ];
  bool show = false;
  String title = "用户详情";
  TextEditingController usernameController =
  TextEditingController(text: '');
  TextEditingController heightController =
  TextEditingController(text: '');
  TextEditingController weightController =
  TextEditingController(text: '');
  String loading = "##loading##";
  static const loadingTag = "##loading##"; //表尾标记
  var words = <String>[loadingTag];
  List textList = ["修改头像", "姓名或昵称", "性别", "身高(cm)", "体重(kg)", "出生日期"];
  List userList = ["修改头像", "", "性别", "", "", "点击选择"];
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

  void setUI() {
    if (affiliateModel.id  == 0) {
        title = '添加用户';
        return;
    }
    usernameController = TextEditingController(text: affiliateModel.nickname);
    heightController = TextEditingController(text: affiliateModel.height.toString());
    weightController = TextEditingController(text: affiliateModel.weight.toString());
     userList = ["修改头像", "" , affiliateModel.sex == "F" ? '男' : '女', "", "", DateTime.parse(affiliateModel.birthday).toString().substring(
         0, DateTime.parse(affiliateModel.birthday).toString().length - 13)];
  }
  void back(){
    navigate.pop();
  }
   void add() async {
//     affiliateModel.nickname = "111111";
//     affiliateModel.sex = "F";
//     affiliateModel.birthday = "2019-10-22";
//     affiliateModel.height = 100;
//     affiliateModel.phone = "17628045052";
//     affiliateModel.weight = 10;
//
//     Result<Affiliate> response = await AffiliateApis.modifyAffiliate(affiliateModel);
//     bool code = response.success;

  }

  void delAffiliate() async {
    Result<Affiliate> response = await AffiliateApis.delAffiliate(affiliateModel);
    bool code = response.success;
    if(code) {
      navigate.pop();
    }
  }
}
