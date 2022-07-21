import 'package:app/view/home/HomePage.dart';
import 'package:app/view/mall/iwaMall/IwaMallPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/base/util/BlocUtils.dart';
class SuccessfulPaymentPage extends StatelessWidget {
  // const SuccessfulPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          child: Center(
            child: Text('关闭',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20
              ),
            ),
          ),
          onTap: (){
            Navigator.of(context).pushAndRemoveUntil(//跳转到积分商城首页
                MaterialPageRoute(builder: (context) => IwaMallPage()),
                    (route) => route == null
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Color(0xFFE94F1C),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,color: Colors.white,size: 30),
                  SizedBox(width: 10),
                  Text('支付成功',style: TextStyle(color: Colors.white,fontSize: 25))
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey[300],
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.all(10),
                    width: 110,
                    alignment: Alignment.center,
                    child: Text('再逛逛',style: TextStyle(fontSize: 18)),
                  ),
                  onTap: (){
                    Navigator.of(context).pushAndRemoveUntil(//跳转到积分商城首页
                        MaterialPageRoute(builder: (context) => IwaMallPage()),
                            (route) => route == null
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey[300],
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.all(10),
                    width: 110,
                    alignment: Alignment.center,
                    child: Text('查看订单',style: TextStyle(fontSize: 18)),
                  ),
                  onTap: (){//前往订单详情列表
                    // Navigator.pushNamed(context,'/orderDetail');
                    Navigator.of(context).pushReplacementNamed('/orderDetail');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
