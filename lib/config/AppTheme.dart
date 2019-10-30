import 'package:flutter/material.dart';

/*
textsize_time_light = 40.0        // 只能为阿拉伯数字信息, 如金额/时间等
textsize_result_medium = 20.0     // 页面大标题, 一般用于结果, 空状态等信息单一页面
textsize_button_regular = 18.0    // 页面内大按钮字体, 与按钮搭配使用
textsize_title_regular = 17.0     // 页面内首要层级信息, 基准的, 可以是连续的, 如列表标题/消息气泡
textsize_subtitle_regular = 14.0  // 页面内交要描述信息, 服务于首要信息并与之关联, 如列表摘要
textsize_link_regular = 13.0      // 页面辅助信息, 需弱化的内容, 如连接/小按钮
textsize_copyright_regular = 11.0 // 说明文本, 如版权信息不需要用户关注的信息
*/

ThemeData _buildTheme() {
  ThemeData dt = ThemeData();
  ThemeData theme = dt.copyWith(
    primaryColor: Color(0xffffffff),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: Color(0xffffffff),
    appBarTheme: dt.appBarTheme.copyWith(
      textTheme: TextTheme(
        title: TextStyle(
          color: Color(0xff000000),
          fontSize: 18.0,
        ),
      ),
    ),
    buttonTheme: dt.buttonTheme.copyWith(
      splashColor: Colors.transparent,
      height: 47.0,
      colorScheme: dt.buttonTheme.colorScheme.copyWith(
        primary: Color(0xff46ceb7),
        secondary: Color(0xffffffff),
      ),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(5.0),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: false,
      isCollapsed: false,
      filled: false,
      alignLabelWithHint: false,
      contentPadding: EdgeInsets.only(left: 3, right: 3, top: 20, bottom: 10),
      hintStyle: TextStyle(
        color: Color(0xffcecccd),
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffe3e3e3),
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffe3e3e3),
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 1.0,
          color: Colors.red,
        ),
      ),
    ),
    textTheme: dt.textTheme.copyWith(
      button: dt.textTheme.button.copyWith(
        // FlatButton 默认样式
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
      ),
      body1: dt.textTheme.body1.copyWith(
        // Text 默认样式
        fontSize: 17.0,
      ),
      body2: dt.textTheme.body2.copyWith(fontSize: 14.0),
    ),
    primaryIconTheme: dt.primaryIconTheme.copyWith(
      // AppBar 默认样式
      size: 18.0,
      color: Color(0xff000000),
    ),
    iconTheme: dt.iconTheme.copyWith(
      // IconButton 默认样式
      size: 18.0,
      color: Color(0xff000000),
    ),
  );
  return theme;
}

final ThemeData appTheme = _buildTheme();
