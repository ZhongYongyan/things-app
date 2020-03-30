import 'package:app/base/api/AffiliateApis.dart';
import 'package:app/base/entity/Affiliate.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/Result.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

class DatailsBloc extends BlocBase with LoggingMixin {
  DatailsBloc(BuildContext context, Store store) : super(context, store);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController heightController = TextEditingController(text: '');
  TextEditingController weightController = TextEditingController(text: '');
  String loading = "##loading##";
  static const loadingTag = "##loading##"; //表尾标记
  var words = <String>[loadingTag];
  List textList = ["修改头像", "姓名或昵称", "性别", "身高(cm)", "体重(kg)", "出生日期"];
  List userList = ["修改头像", "", "点击选择", "点击选择", "点击选择", "点击选择"];
  String text = "最新";
  String imgPath = "";
  bool editShow = false;
  bool nameEmpty = false;
  bool loginProcessing = false;
  bool addAffiliateShow = false;
  var heightPickerData = '''
[
    [
        110,
        120,
        130,
        140,
        150,
        160,
        170,
        180,
        190,
        200,
        210,
        220,
        230,
        240,
        250
    ]
]
    ''';
  var weightPickerData = '''
[
    [
        20,
        30,
        40,
        50,
        60,
        70,
        80,
        90,
        100,
        110,
        120,
        130,
        140,
        150,
        160,
        170,
        180,
        190,
        200,
        210,
        220,
        230,
        240,
        250,
        260,
        270,
        280,
        290,
        300
    ]
]
    ''';

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

  void dataClick(String i) {
    setModel(() {
      affiliateModel.birthday = i.substring(0, 10);
    });
  }

  void userClick(String i) {
    setModel(() {
      affiliateModel.sex = i == '男' ? 'F' : 'M';
    });
  }
  void userClickHeight(List i) {
    setModel(() {
      affiliateModel.height = int.parse(i[0]);
    });
  }
  void weightClickHeight(List i) {
    setModel(() {
      affiliateModel.weight = double.parse(i[0]);
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
    if (affiliateModel.id == 0) {
      title = '添加用户';
    }
    if (!editShow) {
      usernameController = TextEditingController(text: affiliateModel.nickname);
      editShow = true;
    }
    userList = [
      "修改头像",
      "",
      affiliateModel.sex == "" ? "点击选择" : affiliateModel.sex == "F" ? '男' : '女',
      affiliateModel.height.toString() == '0'
          ? "点击选择"
          : affiliateModel.height.toString(),
      affiliateModel.weight.toString() == '0.0'
          ? "点击选择"
          : affiliateModel.weight.toString(),
      affiliateModel.birthday == ""
          ? "点击选择"
          : affiliateModel.birthday.substring(0, 10)
    ];
  }

  void toBack() {
    navigate.pop();
  }

  void addAffiliate() async {
    addAffiliateShow = true;
    if (usernameController.text == "" || nameEmpty) {
      if(nameEmpty) {
        toast('昵称限制8位');
        return;
      }
      toast('昵称为空');
      return;
    }
    if (userList[2] == "点击选择") {
      toast('性别为空');
      return;
    }
    if (userList[3] == "点击选择") {
      toast('身高为空');
      return;
    }
    if (userList[4] == "点击选择") {
      toast('体重为空');
      return;
    }
    if (userList[5] == "点击选择") {
      toast('出生日期为空');
      return;
    }
    setModel(() {
      loginProcessing = true;
    });
    var data = affiliateModel.birthday.substring(0, 10);
    affiliateModel.birthday = data.replaceAll('-', '/') + ' 23:23:23';
    print(affiliateModel);
    Result<Affiliate> response =
        await AffiliateApis.modifyAffiliate(affiliateModel);
    bool code = response.success;
    setModel(() {
      loginProcessing = false;
    });
    if (code) {
      Fluttertoast.showToast(
          msg: "保存成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      navigate.pop();
    } else {
      String message = response.message;
      Fluttertoast.showToast(
          msg: "保存失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      print(message);
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
          msg: "删除成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      navigate.pop();
    } else {
      Fluttertoast.showToast(
          msg: "删除失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void toast(String name) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Color(0xFF0079FE),
        duration: Duration(milliseconds: 1500),
        content: SizedBox(
          width: double.infinity,
          height: 40,
          child: Center(
            child: Text(name),
          ),
        ),
      ),
    );
  }
}
