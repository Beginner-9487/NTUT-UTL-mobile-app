import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

class TileLineChartDashboard<XType, YType> extends StatelessWidget with StatelessWidgetWithResStrings {
  TileLineChartDashboard(
      {
        super.key, this.onTap, this.colorBackground,
        required this.labelName,
        this.xLabelName, this.yLabelName,
        this.xUnitName, this.yUnitName,
        this.x, required this.yData
      });

  GestureTapCallback? onTap;
  final Color? colorBackground;
  final String labelName;

  final String? xLabelName;
  final String? yLabelName;
  final String? xUnitName;
  final String? yUnitName;

  final XType? x;
  final List<YType> yData;

  Widget? getXLabel() {
    if(x == null || xLabelName == null) {
      return null;
    }
    return Text("$xLabelName${xLabelName == null ? "" : ": "}$x${xUnitName == null ? "" : " ("}$xUnitName${xUnitName == null ? "" : ")"}");
  }

  List<Widget> getYLabel() {
    return yData.map((e) => Text("$yLabelName${yLabelName == null ? "" : ": "}$e${yUnitName == null ? "" : " ("}$yUnitName${yUnitName == null ? "" : ")"}")).toList();
  }

  @override
  Widget buildWithContext(BuildContext context) {
    return ListTile(
      tileColor: colorBackground,
      title: Text(labelName),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getYLabel(),
      ),
      subtitle: getXLabel(),
      // contentPadding: const EdgeInsets.all(0.0),
      onTap: onTap,
    );
  }
}