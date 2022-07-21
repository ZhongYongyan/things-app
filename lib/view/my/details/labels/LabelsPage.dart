import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:app/view/my/details/labels/LabelsBloc.dart';
import 'package:redux/src/store.dart';
class LabelsPage extends StatefulWidget {
  // const LabelsPage({Key? key}) : super(key: key);

  @override
  State<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends BlocState<LabelsPage,LabelsBloc> {
  @override
  LabelsBloc createBloc(Store<StoreState> store) {
    return LabelsBloc(context, store);
  }

  @override
  Widget createWidget(BuildContext context) {
    // var args = ModalRoute.of(context).settings.arguments as Map;
    // var model = args["model"];
    // bloc.memberInfoModel = model;
    // bloc.initialize();
    bloc.labelsWidth=(MediaQuery.of(context).size.width-70)/3;//单个标签的最小宽度 70=12*2+10*2+2*3+10*2
    Widget body = _pageBody();
    return body;
  }

  _pageBody(){
    return Scaffold(
        key: bloc.scaffoldKey,
        appBar: AppBar(
          //导航栏
          elevation: 0,
          brightness: Brightness.light,
          centerTitle: true,
          title: Text(bloc.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              )),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Color(0xFFF9F9F9),
        body: Container(
          color: Color(0xFFF9F9F9),
          child: SingleChildScrollView(
//          padding: EdgeInsets.all(16.0),
            child: Column(
              //动态创建一个List<Widget>
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  children: labelTitle(),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                              (states){
                            return Colors.white;//默认颜色
                          }
                      ),//文字颜色
                      backgroundColor: MaterialStateProperty.resolveWith(
                              (states){
                            if(states.contains(MaterialState.pressed)){//按下时的颜色
                              return Colors.grey;
                            }
                            return Color.fromRGBO(254, 148, 0, 1);//默认颜色
                          }
                      ),//背景颜色
                    ),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Text(bloc.preservation),
                    ),
                    onPressed: bloc.saveHandler,//点击登录
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  /*
  * 标签类别
  * */
  List<Widget> labelTitle(){
    var tempList=bloc.allLabels.asMap().entries.map((e){
      return Card(
        margin: EdgeInsets.all(10),
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
                alignment: Alignment.topLeft,
                child: Text(e.value['title'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFF3F3F3))),
                )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(12,20,12,20),
              width: double.infinity,
              child: Wrap(
                spacing: 10,
                runSpacing: 20,
                children: labels(e.value['labels'],e.key.toInt()),
              )
            )
          ],
        )
      );
    });
    return tempList.toList();
  }

  /*
  * 子类别下的所有标签
  * */
  List<Widget> labels(item,page){
    //map后面要写Widget，不然会报list<dynamic> is not a subtype of type list<Widget>
    var tempList=item.asMap().entries.map<Widget>((e){
      return ChoiceChip(
        padding: EdgeInsets.zero,
        backgroundColor:Colors.white,
        side: BorderSide(
          color: Color(0xFFFF9900),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
        labelPadding: EdgeInsets.all(0),
        selected: e.value['status'],
        onSelected: (isSelected) {
          bloc.choose(isSelected,page,e.key);
        },
        selectedColor: Color(0xFFFF9900),
        label: Container(
          padding: EdgeInsets.all(5),
          constraints: BoxConstraints(minWidth: bloc.labelsWidth),
          child: Text(e.value['name'],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: e.value["status"] ? Colors.white : Color(0xFFFF9900),
            ),
          ),
        ),
      );
    });
    return tempList.toList();
  }
}
