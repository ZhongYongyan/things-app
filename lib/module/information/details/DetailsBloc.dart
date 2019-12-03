import 'package:app/packages.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class DetailsBloc extends BlocBase with LoggingMixin {
  DetailsBloc(BuildContext context, Store store)
      : super(context, store);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool show = false;

  void startup() {
    log.info("w222222222222222");
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
