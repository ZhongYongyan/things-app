import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/noripple.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/src/store.dart';

import 'HomeManagementBloc.dart';

class HomeManagementPage extends StatefulWidget {
  // const HomeManagementPage({Key? key}) : super(key: key);

  @override
  State<HomeManagementPage> createState() => _HomeManagementPageState();
}

class _HomeManagementPageState extends BlocState<HomeManagementPage,HomeManagementBloc> {

  @override
  HomeManagementBloc createBloc(Store<StoreState> store) {
    return HomeManagementBloc(context, store)..start();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: () {
  //       print("onWillPop");
  //       // true 当前路由出栈退出
  //       return Future.value(true);
  //     },
  //   );
  // }

  @override
  Widget createWidget(BuildContext context) {
    return WillPopScope(
        child: Container(
          // margin: EdgeInsets.only(top: 100),//状态栏高度
          // margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),//状态栏高度
          height: double.infinity,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.jpg'),
                  fit: BoxFit.cover
              )
          ),
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                title: Text(bloc.title,style: TextStyle(color: Color(0xFF2681FF))),
                centerTitle: true,
                shape: Border(bottom: BorderSide(color:Color(0xFF2681FF))),
              ),
              body: SafeArea(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            gradient:LinearGradient(
                                begin: Alignment(0.0, -1.0),
                                end: Alignment(0.0, 1.0),
                                colors: [Color.fromRGBO(12, 41, 83, 1), Color(0xFF2681ff)]
                            ),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                getText("${bloc.homeName}：", Colors.white,17),
                                // getText(bloc.homeInfo['name'], Colors.white,17,1),
                                // getText(bloc.homeSuffix, Colors.white,17,1),
                                bloc.isEdit?
                                Expanded(
                                  child: TextField(
                                    controller: bloc.homeNameController,
                                    focusNode: bloc.homeNameFocus,
                                    style: TextStyle(fontSize: 17.0, color: Colors.white),
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      isCollapsed:true,//去掉系统默认高度
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]')),
                                      LengthLimitingTextInputFormatter(15)
                                    ],
                                    textInputAction: TextInputAction.done,
                                  ),
                                ):Expanded(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: getText(bloc.homeInfo['name']+bloc.homeSuffix, Colors.white,17,1),
                                      ),
                                      GestureDetector(
                                        child: Icon(Icons.edit,color: Colors.white),
                                        onTap: (){
                                          FocusScope.of(context).requestFocus(bloc.homeNameFocus);
                                          bloc.editName();
                                        },
                                      )
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                getText("${bloc.createTime}：", Colors.white,17,1),
                                getText(bloc.homeInfo['createTime'], Colors.white,17,1),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF2681FF)),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                child: getText(bloc.familyMembers, Colors.white,17),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color(0xFF2681FF)))
                                ),
                              ),
                              Flexible(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: bloc.members.length,
                                  itemBuilder: (content,index){
                                    return ListTile(
                                      leading: CircleAvatar(
                                        radius: 20,
                                        foregroundImage: NetworkImage(bloc.members[index]['img']),
                                      ),
                                      title: getText(bloc.members[index]['name'], index==0?Color(0xFF00FFFF):Colors.white,16),
                                      subtitle: index==0 ? null : getText("${bloc.joinDate}：${bloc.members[index]['createTime']}", Color(0xFF2681FF),13),
                                      trailing: GestureDetector(
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 100,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                gradient:LinearGradient(
                                                    begin: Alignment(0.0, -1.0),
                                                    end: Alignment(0.0, 1.0),
                                                    colors: [Color.fromRGBO(12, 41, 83, 1), Color(0xFF2681ff)]
                                                ),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: Text(index==0?bloc.creator:bloc.delete,style: TextStyle(color: Colors.white)),
                                          ),
                                          onTap: (){
                                            if(index>0){
                                              _showAlertDialog1(context,bloc.confirmDeleteMember,bloc.deleteMember,index);
                                            }
                                          }
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    );
                                  },
                                ),
                              )//实现区域内滑动，超出隐藏可滑动
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: (){
                            _showAlertDialog2(context,bloc.confirmDeleteHome,bloc.deleteHomeHandler);
                          },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.resolveWith((states){
                              return Colors.white;//默认颜色
                            }),//文字颜色
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 50,
                            margin: EdgeInsets.only(top:40,bottom: 50),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                gradient:LinearGradient(
                                    begin: Alignment(0.0, -1.0),
                                    end: Alignment(0.0, 1.0),
                                    colors: [Color.fromRGBO(12, 41, 83, 1), Color(0xFF2681ff)]
                                ),
                                border: Border.all(color: Color(0xFF00ffff)),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Text(bloc.deleteHome),
                          )
                      ),
                    ],
                  ),
                ),
              )
          ),
        ),
        onWillPop: (){
          bloc.back();
          return Future.value(true);
        }
    );
  }

  //文本
  Widget getText(String data,Color col,double fs,[double h=1.2]){
    return Text(data,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: col,
        fontSize: fs,
        height: h
      ),
    );
  }

  // void _showAlertDialog(BuildContext context) {
  //   showCupertinoModalPopup<void>(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: const Text('Alert'),
  //       content: const Text('Proceed with destructive action?'),
  //       actions: <CupertinoDialogAction>[
  //         CupertinoDialogAction(
  //           /// This parameter indicates this action is the default,
  //           /// and turns the action's text to bold text.
  //           isDefaultAction: true,
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: const Text('No'),
  //         ),
  //         CupertinoDialogAction(
  //           /// This parameter indicates the action would perform
  //           /// a destructive action such as deletion, and turns
  //           /// the action's text color to red.
  //           isDestructiveAction: true,
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Yes'),
  //         )
  //       ],
  //     ),
  //   );
  // }

  void _showAlertDialog1(context,String content,void Function(int) yes,int index){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(content),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(bloc.cancel),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text(bloc.determine),
                onPressed: () {
                  yes(index);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _showAlertDialog2(context,String content,void Function() yes){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(bloc.confirmDeleteHome),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(bloc.cancel),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text(bloc.determine),
                onPressed: () {
                  yes();
                  Navigator.popUntil(context, ModalRoute.withName('/page'));//关闭中间页，回到我的页面
                },
              ),
            ],
          );
        });
  }
}
