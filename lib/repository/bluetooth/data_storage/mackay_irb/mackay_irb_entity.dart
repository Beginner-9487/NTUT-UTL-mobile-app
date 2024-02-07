import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ntut_utl_mobile_app/repository/bluetooth/data_storage/mackay_irb/mackay_irb_type.dart';
import 'package:ntut_utl_mobile_app/utils/bytes_converter.dart';
import 'package:ntut_utl_mobile_app/utils/other_useful_function.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class MackayIrbEntity extends Equatable {

  static double get xPrecision => 1000.0;
  static double get yPrecision => 1000000.0;

  String name;
  int type;
  int numberOfData;
  List<Point<double>?> data = [];
  bool finished = false;

  MackayIrbEntity(this.name, this.type, this.numberOfData);

  addNewData(List<int> v) {
    int index = BytesConverter.byteArrayToSignedInt([v[0], v[1]]);
    while(data.length < index-1) {
      data.add(null);
    }
    double voltage = BytesConverter.byteArrayToSignedInt([v[2], v[3]]) + (BytesConverter.byteArrayToSignedInt([v[4], v[5]]).toDouble() / xPrecision);
    double current = BytesConverter.byteArrayToSignedInt([v[6], v[7]]) + (BytesConverter.byteArrayToSignedInt([v[8], v[9], v[10], v[11]]).toDouble() / yPrecision);
    data.add(
        Point(voltage, current)
    );
    if(data.length == numberOfData) {
      finish();
    }
  }

  finish() {
    finished = true;
    _saveExcelFile();
  }

  _saveExcelFile() async {
    debugPrint("_saveExcelFile");
    final String localPath = await OtherUsefulFunction.localPath;
    debugPrint("_saveExcelFile - path: $localPath");
    final String filePath = "$localPath/$name - ${MackayIrbType.getTypeNameWithoutStr(type)}.xlsx";
    File file = File(filePath);
    debugPrint("_saveExcelFile - File: $filePath");
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    for((int, Point<double>?) point in data.indexed) {
      if(point.$2 == null) {continue;}
      sheet.getRangeByIndex(point.$1 + 1, 1).setText("${point.$2!.x}");
      sheet.getRangeByIndex(point.$1 + 1, 2).setText("${point.$2!.y}");
    }
    final List<int> bytes = workbook.saveAsStream();
    file.writeAsBytes(bytes);
    workbook.dispose();
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

  @override
  List<Object?> get props => [];
}