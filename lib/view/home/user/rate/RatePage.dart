import 'package:app/base/util/BlocUtils.dart';
import 'package:app/store/Store.dart';
import 'package:app/view/home/user/rate/RateBloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class RatePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends BlocState<RatePage, RateBloc> {
  @override
  RateBloc createBloc(Store<StoreState> store) {
    return RateBloc(context, store)..startup();
  }

  @override
  Widget createWidget(BuildContext context) {
    bloc.w = MediaQuery.of(context).size.width;
    Widget body = _pageBody();
    return body;
  }

  _pageBody() {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[LineChartSample3()],
          ),
        ),
      ),
//
    );
  }
}

class LineChartSample3 extends StatelessWidget {
  final weekDays = [
    '10-1',
    '10-1',
    '10-1',
    '10-1',
    '10-1',
    '10-1',
    '10-1',
    '10-1',
    '10-1',
    '10-1',
    '10-1',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          height: 200,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((spotIndex) {
                      final FlSpot spot = barData.spots[spotIndex];
//                      if (spot.x == 0 || spot.x == 11) {
//                        return null;
//                      }
                      return TouchedSpotIndicatorData(
                        const FlLine(color: Colors.red, strokeWidth: 1),
                        const FlDotData(
                            dotSize: 4, dotColor: Colors.deepOrange),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.red,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final flSpot = barSpot;
//                          if (flSpot.x == 0 || flSpot.x == 11) {
//                            return null;
//                          }

                          return LineTooltipItem(
                            '${weekDays[flSpot.x.toInt()]} \n${flSpot.y} k colories',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      })),
              extraLinesData:
                  ExtraLinesData(showVerticalLines: true, verticalLines: [
//                VerticalLine(
//                  y: 1.8,
//                  color: Colors.green.withOpacity(0.7),
//                  strokeWidth: 4,
//                ),
              ]),
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 1.3),
                    FlSpot(1, 1),
                    FlSpot(2, 1.8),
                    FlSpot(3, 2),
                    FlSpot(4, 2.2),
                    FlSpot(5, 2),
                    FlSpot(6, 1.8),
                    FlSpot(7, 3),
                    FlSpot(8, 2),
                    FlSpot(9, 1),
                    FlSpot(10, 4),
                  ],
                  isCurved: false,
                  barWidth: 1,
                  colors: [
                    Color(0xff238BFD)
//                    Colors.orange,
                  ],
                  dotData: FlDotData(
                      show: true,
                      dotColor: Color(0xff238BFD),
                      dotSize: 4,
                      checkToShowDot: (spot) {
                        return spot.x != 11;
                      }),
                ),
              ],
              minY: 0,
              gridData: FlGridData(
                show: true,
                drawHorizontalGrid: true,
                drawVerticalGrid: true,
                getDrawingHorizontalGridLine: (value) {
                  if (value == 4 || value == 0) {
                    return const FlLine(
                      color: Color(0xffE9EAEB),
                      strokeWidth: 1.5,
                    );
                  } else {
                    return const FlLine(
                      color: Color(0xffE9EAEB),
                      strokeWidth: 0.5,
                    );
                  }
                },
                getDrawingVerticalGridLine: (value) {
                  if (value == 0 || value == 10) {
                    return const FlLine(
                      color: Colors.white,
                      strokeWidth: 2,
                    );
                  } else {
                    return const FlLine(
                      color: Colors.white,
                      strokeWidth: 2,
                    );
                  }
                },
              ),
              titlesData: FlTitlesData(
                  show: true,
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      switch (value.toInt()) {
                        case 0:
                          return '';
                        case 1:
                          return '1';
                        case 2:
                          return '2';
                        case 3:
                          return '3';
                        case 4:
                          return '4';
                      }

                      return '';
                    },
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      return weekDays[value.toInt()];
                    },
                    textStyle: const TextStyle(color: Colors.black, fontSize: 12

//                      fontWeight: FontWeight.bold,
                        ),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
