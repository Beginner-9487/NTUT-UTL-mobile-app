import 'dart:math';

import 'other_info.dart';

class PointsConverter {
  static const int NONE = 0;
  static const int REAL = 1;
  static const int SCREEN = 2;

  static pointsConverter(List<Point> points, [int? pointConverterNo]) {
    pointConverterNo ??= NONE;
    switch (pointConverterNo) {
      case NONE:
        return points;
      case REAL:
        return toRealPoints(points);
      case SCREEN:
        return toScreenPoints(points);
    }
    return [];
  }

  static toRealPoints(List<Point> points) {
    return points;
  }

  static toScreenPoints(List<Point> points) {
    return points;
  }
}

class FootSensorPoints {

  static List<Point> getAllSensorPoints([int? pointConverterNo]) {
    List<Point> entries = [];
    entries.addAll(PointsConverter.pointsConverter(_Foot_Left, pointConverterNo));
    entries.addAll(PointsConverter.pointsConverter(_Foot_Right, pointConverterNo));
    return entries;
  }

  static List<Point> getPointsByBodyPart(int bodyPart,  [int? pointConverterNo]) {
      List<Point> points = [];
      switch (bodyPart) {
      case BodyPartEnum.LEFT_FOOT:
      points = _Foot_Left;
      case BodyPartEnum.RIGHT_FOOT:
      points = _Foot_Right;
      }
      return PointsConverter.pointsConverter(_Foot_Left, pointConverterNo);
  }

  static List<Point> _Foot_Left = [
    Point(114, 70),
    Point(162, 72),
    Point(77, 104),
    Point(131, 108),
    Point(185, 113),
    Point(65, 150),
    Point(125, 153),
    Point(184, 158),
    Point(45, 196),
    Point(90, 199),
    Point(139, 201),
    Point(184, 204),
    Point(32, 247),
    Point(80, 249),
    Point(133, 251),
    Point(47, 297),
    Point(177, 253),
    Point(102, 299),
    Point(158, 300),
    Point(48, 351),
    Point(140, 351),
    Point(65, 392),
    Point(111, 391),
    Point(64, 465),
    Point(110, 464),
    Point(63, 514),
    Point(109, 512),
    Point(61, 569),
    Point(108, 567),
    Point(60, 624),
    Point(107, 622),
  ];

  static List<Point> _Foot_Right = [
    Point(339, 70),
    Point(291, 72),
    Point(376, 104),
    Point(322, 108),
    Point(268, 113),
    Point(388, 150),
    Point(328, 153),
    Point(269, 158),
    Point(408, 196),
    Point(363, 199),
    Point(314, 201),
    Point(269, 204),
    Point(421, 247),
    Point(373, 249),
    Point(320, 251),
    Point(276, 253),
    Point(406, 297),
    Point(351, 299),
    Point(295, 300),
    Point(405, 351),
    Point(313, 351),
    Point(388, 392),
    Point(342, 391),
    Point(389, 465),
    Point(343, 464),
    Point(390, 514),
    Point(344, 512),
    Point(392, 569),
    Point(345, 567),
    Point(393, 624),
    Point(346, 622),
  ];
}
