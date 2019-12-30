import 'package:app/base/entity/Info.dart';
import 'package:app/packages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class DetailsBloc extends BlocBase with LoggingMixin {
  DetailsBloc(BuildContext context, Store store) : super(context, store);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static const String head =
      '''<!DOCTYPE html><html> <meta charset="utf-8"> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta name="viewport" content="width=device-width, initial-scale=1"> <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/2.1.2/weui.min.css"><link rel="stylesheet" href="https://at.alicdn.com/t/font_1538853_7adh1rzr8ao.css"> <head><title>Navigation Delegate Example</title></head> <body><div class="tit">
  <div class="tit_l"></div><span>''';
  static const String food = '''</div></body>
<style>
img{
  width:250px;
  height: 188px;
  margin: 0 auto;
  display: block;
  padding: 0;
}
p{
  font-size:12px;
  line-height: 24px;
  margin: 0;
  padding: 0;
  color: #666;
  margin-top: 20px;
}
.text{
  padding: 0 20px;
  margin: 0;
  margin-top: -10px;
}
.tit{
  display: flex;
  margin: 20px;
  margin-bottom: 0;
}
.tit_l{
  width: 5px;
  height: 20px;
  background-color: #0179FF;
  margin-top: 2px;
}
.tit span{
  font-weight: 700;
  font-size: 16px;
  color: #666;
  margin-left: 10px;
}
.time{
  font-size: 12px;
  color: #999999;
  text-align: left;
  line-height: 24px;
  margin: 20px;
  margin-top: 5px;
  margin-bottom: 15px;
}
.iconfont {
  font-size: 12px;
  line-height: 24px;
  margin-left: 5px;
  margin-right: 2px;
}
</style>
<script>
  function callFlutter(text) {
    Toast.postMessage("点击了页面主操作按钮" + text);
  }
  
</script>
</html>''';
  bool show = false;
  var infoModel = Info.fromJson({});
  String html;

  void startup() {}

  void setUI() {
    setModel(() {
      html = head +
          infoModel.title +
          '''</span></div>
  <div class="time">
    <span style="margin-left: 0px;" class="iconfont icon-Group-"></span><span>''' +
          infoModel.updated +
          '''</span><span class="iconfont icon-yonghu"></span><span>李小明</span><span class="iconfont icon-yanjing"></span><span>''' +
          infoModel.hits.toString() +
          '''</span>
  </div>
    <div class="text">''' +
          infoModel.body +
          food;
    });
  }

  void to(String text) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 1500),
        backgroundColor: Color(0xFF0079FE),
        content: SizedBox(
          width: double.infinity,
          height: 40,
          child: Center(
            child: Text(text),
          ),
        ),
      ),
    );
    //navigate.pushReplacementNamed('/homeCon');
  }
}
