import 'package:app/store/module/lang/Lang.dart';
import 'package:app/store/module/lang/Langs.dart';
import 'package:flutter/material.dart';
class Loading extends StatelessWidget {
  // const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.2),
          child: Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xFF585858)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(strokeWidth: 2.0,color: Colors.white),
                  SizedBox(height: 15),
                  Text(LangState().localized(Langs.loading),style: TextStyle(fontSize: 14))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
