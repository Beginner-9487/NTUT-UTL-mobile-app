import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/data_storage/ble_data_storage_interface.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/data_storage/mackay_irb/ble_data_storage_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/data_storage/mackay_irb/mackay_irb_entity.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/data_storage/mackay_irb/mackay_irb_type.dart';
import 'package:ntut_utl_mobile_app/repository/line_chart/line_chart_storage_interface.dart';
import 'package:ntut_utl_mobile_app/repository/line_chart/line_data_entity.dart';

class LineDataEntityMackayIRB extends LineDataEntity {
  String labelName;
  int type;
  LineDataEntityMackayIRB(this.labelName, this.type, {required super.realPoints, required super.lineChartPoints});

  factory LineDataEntityMackayIRB.addNewData(int dataIndex, int dataSize, String labelName) {
    return LineDataEntityMackayIRB(
        labelName,
        MackayIrbType.NONE,
        realPoints: [],
        lineChartPoints: []
    );
  }

  String getTypeName(AppLocalizations str) {
    return MackayIrbType.getTypeName(type, str);
  }
  String getXLabelName(AppLocalizations str) {
    return MackayIrbType.getXLabelName(type, str);
  }
  String getYLabelName(AppLocalizations str) {
    return MackayIrbType.getYLabelName(type, str);
  }
  String getXUnitName(AppLocalizations str) {
    return MackayIrbType.getXUnitName(type, str);
  }
  String getYUnitName(AppLocalizations str) {
    return MackayIrbType.getYUnitName(type, str);
  }
}

class LineChartStorageMackayIRB extends LineChartStorageInterface<List<LineDataEntityMackayIRB>, double> {

  BLEDataStorageEvent bleDataStorageEvent;
  late StreamSubscription<void> _onLineDataUpdateSubscription;
  List<LineDataEntityMackayIRB> lineData = [];
  // List<LineDataEntityMackayIRB> get lineData {
  //   LineDataEntityMackayIRB a = LineDataEntityMackayIRB.addNewData(0, 3, "AAA");
  //   LineDataEntityMackayIRB b = LineDataEntityMackayIRB.addNewData(1, 3, "BB");
  //   LineDataEntityMackayIRB c = LineDataEntityMackayIRB.addNewData(2, 3, "C");
  //   a.lineChartPoints = [Point(5, 2), Point(4, 4), Point(9, 1), Point(4, 2), Point(3, 7), Point(5, 8), ];
  //   a.realPoints = [Point(5, 2), Point(4, 4), Point(9, 1), Point(4, 2), Point(3, 7), Point(5, 8), ];
  //   b.lineChartPoints = [Point(3, 7), Point(3, 4), Point(1, 1), Point(9, 1), Point(9, 7), Point(8, 2), ];
  //   b.realPoints = [Point(3, 7), Point(3, 4), Point(1, 1), Point(9, 1), Point(9, 7), Point(8, 2), ];
  //   c.lineChartPoints = [Point(2, 5), Point(5, 9), Point(9, 6), Point(2, 4), Point(6, 5), Point(3, 5), ];
  //   c.realPoints = [Point(2, 5), Point(5, 9), Point(9, 6), Point(2, 4), Point(6, 5), Point(3, 5), ];
  //   return [a,b,c];
  // }

  LineChartStorageMackayIRB(this.bleDataStorageEvent) {
    _onLineDataUpdateSubscription = bleDataStorageEvent.onDataUpdateSubscription(() {
      _setLineData();
      onLineDataUpdateController.sink.add(lineData);
    });
  }

  LineDataEntityMackayIRB findLineDataByLabelName(String labelName) {
    for(LineDataEntityMackayIRB item in lineData) {
      if(item.labelName == labelName) {
        return item;
      }
    }
    lineData.add(LineDataEntityMackayIRB.addNewData(lineData.length, lineData.length + 1, labelName));
    return lineData.last;
  }

  List<Point<double>> _realPointsToLineChartPoints(List<Point<double>> realPoints) {
    return realPoints;
  }

  _setLineData() {
    lineData.clear();
    debugPrint("_setLineData()1: ${lineData.length}");
    List listEntity = (bleDataStorageEvent.storage as BLEDataStorageMackayIRB).getAllData();
    for(MackayIrbEntity item in listEntity) {
      LineDataEntityMackayIRB entity = findLineDataByLabelName(item.name);
      if(entity.type == MackayIrbType.NONE) {
        entity.type = item.type;
      }
      entity.realPoints.addAll(
          item.data.whereType<Point<double>>().toList()
      );
      entity.lineChartPoints.addAll(
          _realPointsToLineChartPoints(
              item.data.whereType<Point<double>>().toList()
          )
      );
      lineData.add(entity);
    }
    debugPrint("_setLineData()2: ${lineData.length}");
  }
}