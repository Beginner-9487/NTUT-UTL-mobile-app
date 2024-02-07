import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntut_utl_mobile_app/repository/line_chart/line_chart_storage_concrete_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/line_chart/mackay_irb/line_chart_bloc_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/line_chart/mackay_irb/line_chart_event_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/line_chart/mackay_irb/line_chart_state_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/utils/other_useful_function.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartViewMackayIrb extends StatefulWidget {
  PageStorageKey pageStorageKey;
  LineChartViewMackayIrb(this.pageStorageKey, {super.key});

  static get ROUTER_NAME => '/LineChartViewMackayIrb';

  @override
  State<LineChartViewMackayIrb> createState() => _LineChartViewMackayIrbState();
}

class _LineChartViewMackayIrbState extends State<LineChartViewMackayIrb> with StatefulWithResStrings {
  LineChartBlocMackayIrb lineChartBlocMackayIrb = LineChartBlocMackayIrb();

  List<LineDataEntityMackayIRB> get _data => lineChartBlocMackayIrb.lineChartData;

  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
      // Enables the trackball
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipAlignment: ChartAlignment.near,
    );
    super.initState();
  }

  @override
  void dispose() {
    lineChartBlocMackayIrb.add(LineChartEventDisposeMackayIrb());
    super.dispose();
  }

  List<LineSeries<Point<double>, double>> getLineGraph() {
    List<LineSeries<Point<double>, double>> list = [];
    int dataIndex = 0;
    int dataSize = _data.length;
    for(LineDataEntityMackayIRB item in _data) {
      list.add(
          LineSeries<Point<double>, double>(
              dataSource: item.lineChartPoints,
              xValueMapper: (Point<double> data, _) => data.x,
              yValueMapper: (Point<double> data, _) => data.y,
              color: OtherUsefulFunction.dataColorfulGenerator(0.75, dataIndex, dataSize),
              name: item.labelName,
          )
      );
      dataIndex++;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LineChartBlocMackayIrb, LineChartStateMackayIrb>(
        bloc: lineChartBlocMackayIrb,
        builder: (context, blueState) {
          return Scaffold(
              body: Center(
                  child: SfCartesianChart(
                      series: getLineGraph(),
                      trackballBehavior: _trackballBehavior,
                      onTrackballPositionChanging: (TrackballArgs trackballArgs) => {
                        lineChartBlocMackayIrb.add(LineChartEventSetLineChartXMackayIrb(
                          _data[0].lineChartPoints[trackballArgs.chartPointInfo.dataPointIndex!].x
                        )),
                      },
                  )
              )
          );
        }
    );
  }
}