import 'dart:typed_data';
import 'dart:math';

import 'package:ntut_utl_mobile_app/repository/ai_module/ai_module_interface.dart';
import 'package:ntut_utl_mobile_app/repository/ai_module/foot_magnets_convert_into_pressure.dart';
import 'package:ntut_utl_mobile_app/utils/bytes_converter.dart';
import 'package:ntut_utl_mobile_app/utils/iterator_processor.dart';

import 'foot_sensor_points.dart';
import 'other_info.dart';

class FootEntity {
  static AIModule aiModule = FootMagnetsConvertIntoPressure();
  static int sequenceIDCounter = 0;
  static int _getNewSequenceID() {
    sequenceIDCounter++;
    return sequenceIDCounter - 1;
  }

  late int bodyPart;
  late int sequenceID;

  List<List<double>> mapFloatList = [];
  List<Point> mapCenter = List<Point>.filled(MapFloatListEnum.ALL_MAP_LENGTH, const Point(0,0));
  List<double> mapAverage = List<double>.filled(MapFloatListEnum.ALL_MAP_LENGTH, 0);
  List<List<double>> mapDirection = [];

  Float32List imuFloat = Float32List(IMUFloatEnum.IMU_LENGTH);

  FootEntity(List<int> bytes) {

    sequenceID = _getNewSequenceID();

    Int8List int8List = Int8List.fromList(bytes);
    IteratorProcessor<int> iterator = IteratorProcessor(int8List);

    bodyPart = iterator.takeOut();

    // imuFloat
    for (int i = 0; i < IMUFloatEnum.IMU_LENGTH; i++) {
      int numberOfByte = IMUFloatEnum.defaultNumberOfByte;
      if (IMUFloatEnum.Triple.contains(i)) {
        numberOfByte = 3;
      }
      imuFloat[i] = BytesConverter.byteArrayToSignedInt(
        iterator.takeOutReversedList(numberOfByte),
      ).toDouble();
    }

    // mapFloatList, mapEntry
    for (int m = 0; m < MapFloatListEnum.ORIGIN_MAP_LENGTH; m++) {
      mapFloatList.add(List<double>.filled(getNumberOfSensor(), 0));
      mapDirection.add(List<double>.filled(getNumberOfSensor(), 0));

      for (int i = 0; i < getNumberOfSensor(); i++) {
        // Magnitude
        int numberOfByte = MapFloatListEnum.defaultNumberOfByte;
        if (MapFloatListEnum.Once.contains(m)) {
          numberOfByte = 1;
        }
        mapFloatList[m][i] = BytesConverter.byteArrayToUnsignedInt(
          iterator.takeOutReversedList(numberOfByte)
        ).toDouble();

        // Average, Center
        mapAverage[m] += mapFloatList[m][i];
        Point currentPosition = getSensorPoints()[i];
        mapCenter[m] = Point(
            mapCenter[m].x + currentPosition.x * mapFloatList[m][i],
            mapCenter[m].y + currentPosition.y * mapFloatList[m][i]
        );
      }

      // Average, Center
      mapCenter[m] = Point(
          mapCenter[m].x / mapAverage[m],
          mapCenter[m].y / mapAverage[m]
      );
      mapAverage[m] /= getNumberOfSensor();
    }

    // calculated map
    mapFloatList.add(List<double>.filled(getNumberOfSensor(), 0));
    mapFloatList.add(List<double>.filled(getNumberOfSensor(), 0));
    mapFloatList.add(List<double>.filled(getNumberOfSensor(), 0));

    for (int i = 0; i < getNumberOfSensor(); i++) {
      List<double> output = aiModule.calculate([
        mapFloatList[MapFloatListEnum.MagX][i],
        mapFloatList[MapFloatListEnum.MagY][i],
        mapFloatList[MapFloatListEnum.MagZ][i],
      ]);
      mapFloatList[MapFloatListEnum.ShearForceX][i] = output[0];
      mapFloatList[MapFloatListEnum.ShearForceY][i] = output[1];
      mapFloatList[MapFloatListEnum.Pressures][i] = output[2];
    }
  }

  List<Point> getSensorPoints() {
    return FootSensorPoints.getPointsByBodyPart(bodyPart);
  }

  int getNumberOfSensor() {
    return FootSensorPoints.getPointsByBodyPart(bodyPart).length;
  }

  Point getVectorMagnitudeDirection(int index, int X, int Y, [Point? center]) {
    center ??= const Point(0, 0);
    double x = mapFloatList[X][index] - center.x;
    double y = mapFloatList[Y][index] - center.y;
    return Point(
      sqrt(pow(x, 2) + pow(y, 2)),
      atan2(x, y),
    );
  }
}
