import 'dart:convert';

import 'package:app/base/blue/Message.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/Utils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/plugin/PluginBloc.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:redux/src/store.dart';

class PluginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<PluginPage, PluginBloc> {
  @override
  void initState() {
    // 强制横屏
//    SystemChrome.setPreferredOrientations(
//        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log.info('addPostFrameCallback');
      var args = ModalRoute.of(context).settings.arguments as Map;
      String deviceSn = args["deviceSn"];
      var url = args["url"] != ""
          ? args["url"]
          : 'http://dev.mp.hswl007.com/things-plugin-a800.zip';
      url.toString().endsWith('.zip')
          ? bloc.loadPlugin(url, deviceSn)
          : bloc.setModel(() {
        if(deviceSn == null) {
          bloc.pluginPath = url;
        }else {
          bloc.pluginPath = url + '?accessToken=' + bloc.state.auth.accessToken + '&deviceSn=' + deviceSn;
        }
      });
    });
  }

  @override
  PluginBloc createBloc(Store<StoreState> store) {
    return PluginBloc(context, store)..init();
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

  @override
  void dispose() {
    bloc.blueBridge.disconnect();
    // 显示顶部状态栏和底部操作栏
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // 强制竖屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//    bloc.navigate.pop();
  }

  _pageBody() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: nonEmpty(bloc.pluginPath)
          ? new WebviewScaffold(
              javascriptChannels: [
                JavascriptChannel(
                    name: 'BlueNative',
                    onMessageReceived: (JavascriptMessage message) {
                      bloc.blueBridge.handleMessage(message.message);
                    }),
                JavascriptChannel(
                    name: 'PluginNative',
                    onMessageReceived: (JavascriptMessage message) {
                      bloc.handleNavigate(message.message);
                    }),
              ].toSet(),
//        url: 'https://www.baidu.com/',
              url: bloc.pluginPath,
              withZoom: true,
              withLocalStorage: true,
              hidden: true,
              ignoreSSLErrors: true,
              withJavascript: true,
              allowFileURLs: true,
              appBar: bloc.loading
                  ? AppBar(
                      elevation: 0,
                      brightness: Brightness.light,
                      centerTitle: true,
                      leading: new IconButton(
                        icon: Container(
                          margin: const EdgeInsets.only(top: 2.0),
                          child: Image(
                            image: AssetImage("assets/back.png"),
                            fit: BoxFit.cover,
                            width: 22,
                            height: 22,
                          ),
                        ),
                        onPressed: () {
                          bloc.toBack();
                        },
                      ),
                    )
                  : null,
              initialChild: Container(
                color: Colors.white,
                child: const Center(
                  child: Text('加载中...'),
                ),
              ),
            )
          : Container(
              color: Colors.white,
              child: const Center(
                child: Text('加载中...'),
              ),
            ),
    );
  }
}
