import 'package:app/base/entity/Info.dart';
import 'package:app/base/entity/MemberNews.dart';
import 'package:app/packages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class MsgDetailsBloc extends BlocBase with LoggingMixin {
  MsgDetailsBloc(BuildContext context, Store store) : super(context, store);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static const String head = '''<!DOCTYPE html><html> <meta charset="utf-8"> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta name="viewport" content="width=device-width, initial-scale=1"> <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/2.1.2/weui.min.css"><link rel="stylesheet" href="https://at.alicdn.com/t/font_1538853_7adh1rzr8ao.css"> <head><title>Navigation Delegate Example</title></head> <body>''';
  static const String food = '''</body>
<style>
img{
  width:250px;
  height: 188px;
  margin: 0 auto;
  display: block;
  padding: 0;
}
.text{
  padding: 0 20px;
  margin: 0;
  margin-top: 10px;
  font-size:12px;
  line-height: 24px;
  color: #666;
}

</style>
<script>
  function callFlutter(text) {
    Toast.postMessage("点击了页面主操作按钮" + text);
  }
  
</script>
</html>''';
  bool show = false;
  var MemberNewsModel = MemberNews.fromJson({});
  String html;

  void startup() {}

  void setUI() {
    setModel(() {
      html = head +'''<div class="text">''' +  MemberNewsModel.body + '''</div>''' + food;
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
