import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartViewFootImu extends StatefulWidget {
  PageStorageKey pageStorageKey;
  LineChartViewFootImu(this.pageStorageKey, {super.key});

  static get ROUTER_NAME => '/LineChartViewFootImu';

  @override
  State<LineChartViewFootImu> createState() => _LineChartViewFootImuState();
}

class _LineChartViewFootImuState extends State<LineChartViewFootImu> with StatefulWithResStrings {
  late TrackballBehavior _trackballBehavior;
  final List<ChartData> data = <ChartData>[
    ChartData('Jan', 15, 39, 60),
    ChartData('Feb', 20, 30, 55),
    ChartData('Mar', 25, 28, 48),
    ChartData('Apr', 21, 35, 57),
    ChartData('May', 13, 39, 62),
    ChartData('Jun', 18, 41, 64),
    ChartData('Jul', 24, 45, 57),
    ChartData('Aug', 23, 48, 53),
    ChartData('Sep', 19, 54, 63),
    ChartData('Oct', 31, 55, 50),
    ChartData('Nov', 39, 57, 66),
    ChartData('Dec', 50, 60, 65),
  ];

  List<Widget> pairTrackballDetails(List<CartesianChartPoint<dynamic>>? list) {
    if(list == null) {
      return [];
    }
    List<Widget> pairs = [];
    for (int i = 0; i < list.length; i += 2) {
      if (i + 1 < list.length) {
        pairs.add(
          Text(
              "$i: ${list[i].y}, $i: ${list[i+1].y}",
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              )
          )
        );
      } else {
        pairs.add(
            Text(
              "$i: ${list[i].y}",
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              )
            )
            // Row(
            //   children: [
            //     Text("$i: ${list[i].y}"),
            //   ],
            // )
        );
      }
    }
    return pairs;
  }

  Widget trackballBuilder(BuildContext context, TrackballDetails trackballDetails) {
    // debugPrint("trackballBuilder: ${trackballDetails.groupingModeInfo!.points.length}");
    // return SizedBox(
    //   height: 200,
    //   child:
    //     Column(
    //       children: [
    //         Text("${trackballDetails.groupingModeInfo!.points[0].x}",
    //           textAlign: TextAlign.left,
    //           style: const TextStyle(
    //             color: Colors.white,
    //             fontSize: 20,
    //           ),
    //         ),
    //         ...pairTrackballDetails(trackballDetails.groupingModeInfo!.points),
    //       ],
    //     )
    // );
    return Container(
      height: 100 + trackballDetails.groupingModeInfo!.points.length * 20,
      width: 250,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 8, 22, 0.75),
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
      child: Column(
        children: [
          Text(
              "${trackballDetails.groupingModeInfo!.points[0].x}",
              style: const TextStyle(
                  fontSize: 26,
                  color: Color.fromRGBO(255, 255, 255, 1)
              )
          ),
          const Padding(
              padding: EdgeInsets.only(left: 5),
              child: SizedBox(
                height: 30,
                width: 30,
              )
          ),
          Row(
            children: [
              Column(
                children: [
                  ...trackballDetails.groupingModeInfo!.points
                      .indexed
                      .where(
                          (e) => e.$1 % 2 == 0)
                      .toList()
                      .map((e) =>
                      Row(
                        children: [
                          Icon(
                              Icons.add_chart,
                              color: Colors.red,
                          ),
                          Text(
                              "${e.$1}: ${e.$2.y}",
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromRGBO(255, 255, 255, 1)
                              )
                          )
                        ],
                      )
                  ),
                ],
              ),
              const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                  )
              ),
              Column(
                children: [
                  ...trackballDetails.groupingModeInfo!.points
                      .indexed
                      .where(
                          (e) => e.$1 % 2 == 1)
                      .toList()
                      .map((e) =>
                      Row(
                        children: [
                          Icon(
                            Icons.add_chart,
                            color: trackballDetails.groupingModeInfo!.visibleSeriesList[e.$1].color,
                          ),
                          Text(
                              "${e.$1}: ${e.$2.y}",
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromRGBO(255, 255, 255, 1)
                              )
                          )
                        ],
                      )
                  ),
                ],
              ),
            ],
          ),
        ],
      )
    );
  }

  @override
  void initState(){
    _trackballBehavior = TrackballBehavior(
        enable: true,
        builder: trackballBuilder,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        markerSettings: const TrackballMarkerSettings(
            height: 10,
            width: 10,
            markerVisibility: TrackballVisibilityMode.visible,
            borderColor: Colors.black,
            borderWidth: 4,
            color: Colors.blue),
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: ChartAlignment.near,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        trackballBehavior: _trackballBehavior,
        series: <LineSeries<ChartData, String>>[
          LineSeries<ChartData, String>(
            dataSource: data,
            markerSettings: const MarkerSettings(isVisible: true),
            name: 'United States of America',
            xValueMapper: (ChartData sales, _) => sales.month,
            yValueMapper: (ChartData sales, _) => sales.firstSale,
          ),
          LineSeries<ChartData, String>(
            dataSource: data,
            markerSettings: const MarkerSettings(isVisible: true),
            name: 'Germany',
            xValueMapper: (ChartData sales, _) => sales.month,
            yValueMapper: (ChartData sales, _) => sales.secondSale,
          ),
          LineSeries<ChartData, String>(
            dataSource: data,
            markerSettings: const MarkerSettings(isVisible: true),
            name: 'United Kingdom',
            xValueMapper: (ChartData sales, _) => sales.month,
            yValueMapper: (ChartData sales, _) => sales.thirdSale,
          )
        ]
    );
  }
}
class ChartData {
  ChartData(
      this.month,
      this.firstSale,
      this.secondSale,
      this.thirdSale
      );

  final String month;
  final double firstSale;
  final double secondSale;
  final double thirdSale;
}