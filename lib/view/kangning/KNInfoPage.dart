import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app/view/home/HomePage.dart';

class KNInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<KNInfoPage> {
  @override
  Widget build(BuildContext context) {

    // return WebView(
    //     initialUrl: 'https://irest.m.tmall.com/',
    //     javascriptMode: JavascriptMode.unrestricted,
    //     onWebViewCreated: (WebViewController webViewController){
    //     },
    // );
    return Container(
      child: HomePage(),
    );
  }

}

// class HomeScreenState extends State<KNInfoPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         //导航栏
//         elevation: 0,
//         brightness: Brightness.light,
//         centerTitle: true,
//         title: Text('身心放松',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//             )),
//         backgroundColor: Colors.white,
//       ),
//       body:  new WebView(
//       initialUrl: 'http://xfgf.knjs.com.cn/IRestApp/#/pages/decompress/decompress',
//       javascriptMode: JavascriptMode.unrestricted,
//       onWebViewCreated: (WebViewController webViewController){
//       },
//     ),
//     );
//   }
// }
