import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UI {
  static void toast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}