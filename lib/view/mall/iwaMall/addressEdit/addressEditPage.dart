import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/src/store.dart';
import 'AddressEditBloc.dart';

class AddressEditPage extends StatefulWidget {
  // const AddressEditPage({Key? key}) : super(key: key);

  @override
  State<AddressEditPage> createState() => _AddressEditPageState();
}

class _AddressEditPageState extends BlocState<AddressEditPage,AddressEditBloc> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log.info('addPostFrameCallback');
      var args = ModalRoute.of(context).settings?.arguments;
      if(args != null){
        print('args');
        var arg =args as Map;
        bloc.initData(arg["info"]);
      }
    });
  }

  @override
  AddressEditBloc createBloc(Store<StoreState> store) {
    return AddressEditBloc(context, store);
  }

  @override
  Widget createWidget(BuildContext context) {
    // var args = ModalRoute.of(context).settings.arguments as Map;
    // var address = args["info"];
    // print(address);
    // bloc.addressInfoModel = address;
    // bloc.initPageData(goods);
    // bloc.addressInfoModel.id=1;

    Widget body = _pageBody();
    return body;
  }

  _pageBody(){
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(bloc.addressInfoModel.id==0?bloc.title1:bloc.title2,style: TextStyle(color: Colors.black)),
      ),
      resizeToAvoidBottomInset:false,//防止键盘撑起内容
      body: SafeArea(
        child: Stack(
          children: [
            Form(
                key: bloc.formKey,
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),//禁止滚动
                    itemCount: bloc.addressLabels.length,
                    itemBuilder: this._getInfoData,
                    separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: Color(0xFFF3F3F3),
                    ),
                  ),
                )
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFE94F1C),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(bloc.preservation,
                    style: TextStyle(
                        color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700
                    )
                  ),
                ),
                onTap: (){
                  bloc.editAddress();
                },
              ),
            ),
            bloc.submitLoading?
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.grey.withOpacity(0.3),
                  child: Center(
                    child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                )
            ):
            Container()
          ],
        ),
      ),
    );
  }

  Widget _getInfoData(content,index){
    return GestureDetector(
      child: Container(
        // height: 50,
        constraints: BoxConstraints(minHeight: 50,maxHeight: index==3?200:50),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text(bloc.addressLabels[index],style: TextStyle(fontSize: 18)),
            ),
            Expanded(
              flex: 2,
              child: index==2?
              GestureDetector(
                child: Text(bloc.addressInfoModel.province==''?bloc.labelsPlaceholder[index]:"${bloc.addressInfoModel.province} ${bloc.addressInfoModel.city} ${bloc.addressInfoModel.area}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: bloc.addressInfoModel.province==''?Color(0xFFcccccc):Colors.black,
                    fontSize: 18
                  ),
                ),
                onTap:()=>{
                  Pickers.showAddressPicker(
                    context,
                    initProvince: bloc.initProvince,
                    initCity: bloc.initCity,
                    initTown: bloc.initTown,
                    addAllItem: false,
                    pickerStyle:PickerStyle(
                        commitButton:Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          margin: const EdgeInsets.only(right: 22),
                          decoration: BoxDecoration(
                              // color: Theme.of(context).primaryColor,
                              color:Color(0xFFE94F1C),
                              borderRadius: BorderRadius.circular(4)),
                          child: Text('确认', style: TextStyle(color: Colors.white, fontSize: 14)),
                        )
                    ),
                    onConfirm: (p, c, t) {
                      bloc.addressRegion(p,c,t);
                    },
                  )
                }
              )
              :index==4?
              Container(
                alignment: Alignment.centerRight,
                child: Switch(
                  value: bloc.addressInfoModel.isDefault,
                  activeColor: Color(0XFFE94F1C),
                  inactiveTrackColor: Color(0xFFcccccc),
                  onChanged: (value) {
                    bloc.defaultAddress(value);
                  },
                ),
              )
              :TextFormField(
                maxLines: index==3?null:1,
                keyboardType:index == 1 ? TextInputType.phone : index == 3 ? TextInputType.multiline : TextInputType.text,
                textAlign:TextAlign.right,
                controller:index == 0 ?  bloc.usernameController : index == 1 ? bloc.phoneController :bloc.streetController,
                style: TextStyle(
                    fontSize: 18.0,
                    color:Colors.black),
                autocorrect: true,
                focusNode: index == 0 ?  bloc.usernameFocus : index == 1 ? bloc.phoneFocus :bloc.streetFocus,
                decoration:InputDecoration(
                  prefixStyle: TextStyle(color: Colors.black),
                  hintText: bloc.labelsPlaceholder[index],
                  border:_inputBorder(),
                  disabledBorder:_inputBorder(),
                  enabledBorder:_inputBorder(),
                  focusedBorder:_inputBorder(),
                  // contentPadding:EdgeInsets.only(left: 20.0),
                  hintStyle:TextStyle(
                      fontSize:18.0,
                      color: Color(0xFFcccccc)),
                ),
                inputFormatters: index == 3?bloc.rule[2]:bloc.rule[index],
                onChanged: (String val){
                  bloc.valueChange(index,val);
                },
              ),
            )
          ],
        ),
      ),
      // onTap: ()=>bloc.viewInfo(index),
    );
  }

  //处理输入框文本靠下的问题
  InputBorder _inputBorder(){
    return OutlineInputBorder(
      // borderSide: BorderSide(width: 0,color: Colors.transparent)
        borderSide: BorderSide.none
    );
  }

}
