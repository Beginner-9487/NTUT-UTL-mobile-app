import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/data_storage/mackay_irb/mackay_irb_type.dart';
import 'package:ntut_utl_mobile_app/repository/line_chart/line_chart_storage_concrete_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/line_chart/mackay_irb/line_chart_bloc_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/line_chart/mackay_irb/line_chart_event_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/line_chart/mackay_irb/line_chart_state_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/ui/widgets/tile_line_chart_dashboard.dart';
import 'package:ntut_utl_mobile_app/utils/other_useful_function.dart';

class LineChartDashboardViewMackayIrb extends StatefulWidget {
  PageStorageKey pageStorageKey;
  LineChartDashboardViewMackayIrb(this.pageStorageKey, {super.key});

  static get ROUTER_NAME => '/LineChartDashboardViewMackayIrb';

  @override
  State<LineChartDashboardViewMackayIrb> createState() => _LineChartDashboardViewMackayIrbState();
}

class _LineChartDashboardViewMackayIrbState extends State<LineChartDashboardViewMackayIrb> with StatefulWithResStrings {
  LineChartBlocMackayIrb lineChartBlocMackayIrb = LineChartBlocMackayIrb();

  List<LineDataEntityMackayIRB> get _data => lineChartBlocMackayIrb.lineChartData;
  double? get _lineChartX => lineChartBlocMackayIrb.lineChartX;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    lineChartBlocMackayIrb.add(LineChartEventDisposeMackayIrb());
    super.dispose();
  }

  static int _buildDataTilesKeyCounter = 0;
  List<TileLineChartDashboard> _buildDataTiles(BuildContext context) {
    return _data.indexed
      .map((e) => TileLineChartDashboard(
      // Using a new (non-existent) key make the system to create
      // a completely different widget thereby changing the widget size
      key: Key("${_buildDataTilesKeyCounter++}"),
      labelName: "${MackayIrbType.getTypeName(e.$2.type, str)}: ${e.$2.labelName}",
      colorBackground: OtherUsefulFunction.dataColorfulGenerator(0.75, e.$1, _data.length),
      xLabelName: e.$2.getXLabelName(str),
      yLabelName: e.$2.getYLabelName(str),
      xUnitName: e.$2.getXUnitName(str),
      yUnitName: e.$2.getYUnitName(str),
      x: e.$2.getRealXByLineChartX(_lineChartX),
      yData: e.$2.getRealYByLineChartX(_lineChartX),
      )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LineChartBlocMackayIrb, LineChartStateMackayIrb>(
        bloc: lineChartBlocMackayIrb,
        builder: (context, blueState) {
          return ListView(
            children: <Widget>[
              ..._buildDataTiles(context),
            ],
          );
        }
    );
  }
}