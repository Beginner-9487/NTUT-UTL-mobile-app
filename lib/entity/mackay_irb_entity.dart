import 'dart:math';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../utils/useful_function.dart';

class MackayIrbEntity extends Equatable {

  static double get xPrecision => 1000.0;
  static double get yPrecision => 1000000.0;

  String name;
  int type;
  int numberOfData;
  List<Point> data = [];
  bool finished = false;

  MackayIrbEntity(this.name, this.type, this.numberOfData);

  addNewData(List<int> v) {
    int index = byteArrayToSignedInt([v[0], v[1]]);
    while(data.length < index-1) {
      data.add(const Point(-65536, -65536));
    }
    double voltage = byteArrayToSignedInt([v[2], v[3]]) + (byteArrayToSignedInt([v[4], v[5]]).toDouble() / xPrecision);
    double current = byteArrayToSignedInt([v[6], v[7]]) + (byteArrayToSignedInt([v[8], v[9], v[10], v[11]]).toDouble() / yPrecision);
    data.add(
      Point(voltage, current)
    );
    if(data.length == numberOfData) {
      finish();
    }
  }

  finish() {
    finished = true;
  }

  @override
  List<Object?> get props => [];

}