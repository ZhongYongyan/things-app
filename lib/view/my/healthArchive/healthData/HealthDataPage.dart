import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'HealthDataBloc.dart';
class HealthDataPage extends StatefulWidget {

  @override
  State<HealthDataPage> createState() => _HealthDataPageState();
}

class _HealthDataPageState extends BlocState<HealthDataPage,HealthDataBloc> {

  @override
  HealthDataBloc createBloc(Store<StoreState> store) {

    return HealthDataBloc(context, store);
  }

  @override
  Widget createWidget(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map;
    bloc.user=args["user"];
    bloc.setup();
    return Container(
      width: double.infinity,
      height: double.infinity,
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
          title: Text(bloc.pageTitle,style: TextStyle(color: Color(0xFF2681FF))),
          centerTitle: true,
          shape: Border(bottom: BorderSide(color:Color(0xFF2681FF))),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient:LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, 1.0),
                        colors: [Color.fromRGBO(12, 41, 83, 1), Color(0xFF2681ff)]
                    ),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('按摩次数',style: TextStyle(color: Colors.white)),
                          SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                                text: "${548}",
                                style: TextStyle(fontSize: 27,color: Color(0xFF00ffff)),
                                children: [
                                  TextSpan(text: '次',style: TextStyle(fontSize: 12,color: Color(0xFF00ffff))),
                                ]),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('累计时长',style: TextStyle(color: Colors.white)),
                          SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                                text: "${1352}",
                                style: TextStyle(fontSize: 27,color: Color(0xFF00ffff)),
                                children: [
                                  TextSpan(text: '分钟',style: TextStyle(fontSize: 12,color: Color(0xFF00ffff))),
                                ]),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.all(20),
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Color(0xFF2681FF)),
                //     borderRadius: BorderRadius.circular(5)
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text('心脏健康',style: TextStyle(fontSize: 20,color: Color(0xFF00ffff))),
                //       Text('3/16心率',style: TextStyle(fontSize: 13,color: Color(0xFF2681FF))),
                //       Container(
                //           padding: EdgeInsets.only(top: 20,bottom: 20),
                //           child: SfSparkLineChart(
                //             color: Color(0xFF00ffff),
                //             axisLineColor: Colors.transparent,
                //             //Enable the trackball
                //             // trackball: SparkChartTrackball(
                //             //     activationMode: SparkChartActivationMode.tap),
                //             //Enable marker
                //             // marker: SparkChartMarker(
                //             //     displayMode: SparkChartMarkerDisplayMode.all),
                //             //Enable data label
                //             // labelDisplayMode: SparkChartLabelDisplayMode.all,
                //             data: <double>[
                //               1, 5, -6, 0, 1, -2, 7, -7, -4, -10, 23, -6, 7, 5, 11, 5, 3,8,5,6,7,3,5,6
                //             ],
                //           )
                //       ),
                //       RichText(
                //         text: TextSpan(
                //             text: "${89}",
                //             style: TextStyle(fontSize: 30,color: Color(0xFF00ffff)),
                //             children: [
                //               TextSpan(text: '次/分钟',style: TextStyle(fontSize: 13,color: Color(0xFF00ffff))),
                //             ]),
                //       )
                //     ],
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF2681FF)),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('血氧饱和度',style: TextStyle(fontSize: 20,color: Color(0xFF00ffff))),
                      Text('3/16',style: TextStyle(fontSize: 13,color: Color(0xFF2681FF))),
                      Container(
                          padding: EdgeInsets.only(top: 20,bottom: 20),
                          child: SfSparkLineChart(
                            color: Color(0xFF00ffff),
                            axisLineColor: Colors.transparent,
                            //Enable the trackball
                            // trackball: SparkChartTrackball(
                            //     activationMode: SparkChartActivationMode.tap),
                            //Enable marker
                            // marker: SparkChartMarker(
                            //     displayMode: SparkChartMarkerDisplayMode.all),
                            //Enable data label
                            // labelDisplayMode: SparkChartLabelDisplayMode.all,
                            data: <double>[
                              1, 5, -6, 0, 1, -2, 7, -7, -4, -10, 23, -6, 7, 5, 11, 5, 3,8,5,6,7,3,5,6
                            ],
                          )
                      ),
                      RichText(
                        text: TextSpan(
                            text: "${100}",
                            style: TextStyle(fontSize: 30,color: Color(0xFF00ffff)),
                            children: [
                              TextSpan(text: '%',style: TextStyle(fontSize: 13,color: Color(0xFF00ffff))),
                            ]),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
