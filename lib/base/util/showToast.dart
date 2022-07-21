import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future showToast(msg) async {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    textColor: Colors.white,
    backgroundColor: Colors.black,
  );
  await Future.delayed(Duration(milliseconds: 1500));
}
