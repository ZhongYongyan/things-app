import 'dart:async';
import 'dart:convert';

import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/config/WifiConfigBloc.dart';
import 'package:app/view/msg/details/DetailsBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:redux/src/store.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WifiConfigPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<WifiConfigPage, WifiConfigBloc> {
  @override
  void initState() {
    super.initState();
  }

  @override
  WifiConfigBloc createBloc(Store<StoreState> store) {
    return WifiConfigBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    Widget body = _pageBody();
    return body;
  }

  _pageBody() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        title: Text("网络配置",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 09),
              child: createForm(),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 09),
                child: createList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: FlatButton(
                    color: Color(0xFF0079FE),
                    onPressed: () {
                      if(!bloc.setuping) {
                        if (_formKey.currentState.validate()) {
                          bloc.submit();
                        }
                      }
                    },
                    child: Text(bloc.setuping ? '正在配置网络...' : '配置网络', style: TextStyle(color: Color(0xffffffff)))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  Widget createForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: bloc.usernameController,
            decoration: const InputDecoration(
              hintText: '网络名称 ',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return '请输入网络名称';
              }
              return null;
            },
          ),
          TextFormField(
            controller: bloc.passwordController,
            decoration: const InputDecoration(
              hintText: '密码',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return '请输入网络密码';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget createList() {
    return EasyRefresh.custom(
      header: BallPulseHeader(),
      controller: bloc.refreshController,
      onRefresh: () async {
        return bloc.startScan();
      },
      enableControlFinishRefresh: true,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var name = bloc.entries.elementAt(index);
              return createListItem(name);
            },
            childCount: bloc.entries.length,
          ),
        ),
      ],
    );
  }

  createListItem(String name) {
    return Container(
        height: 40,
        child: Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                child: Text(name),
                onTap: () {
                  bloc.select(name);
                },
              ),
            ),
            bloc.selectedItem == name
                ? Icon(
                    Icons.check,
                    size: 24.0,
                  )
                : Container()
          ],
        ));
  }
}
