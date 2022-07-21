import 'package:app/base/api/IwaMallApis.dart';
import 'package:app/base/util/BlocUtils.dart';
import 'package:app/base/util/Loading.dart';
import 'package:app/base/util/showToast.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';
import 'ReceiptBloc.dart';

class ReceiptPage extends StatefulWidget {
  final receipt;

  const ReceiptPage(this.receipt, {Key key}) : super(key: key);

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends BlocState<ReceiptPage, ReceiptBloc> {
  bool receipt;
  bool loading=false;
  @override
  ReceiptBloc createBloc(Store<StoreState> store) {
    receipt = widget.receipt == null ? true : false;
    return ReceiptBloc(context, store);
  }

  @override
  Widget createWidget(BuildContext context) {
    return receipt
        ? StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      border:
                      Border.all(color: Colors.grey[300], width: 1),
                      borderRadius: BorderRadius.circular(50)),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  width: 100,
                  alignment: Alignment.center,
                  child: Text(bloc.confirmReceipt,
                      style: TextStyle(fontSize: 16)),
                ),
                onTap: () async {
                  String response = await IwaMallApis.receive(1);
                  print(response);
                  loading=false;
                  if (response != 'null' && response != 'err') {
                    setState(() => receipt = false);
                  }
                  showToast('操作失败');
                },
              )
            ],
          );
        })
        : Container();
  }
}
