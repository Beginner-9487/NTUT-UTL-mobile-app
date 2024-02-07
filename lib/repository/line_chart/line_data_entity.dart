import 'dart:math';

abstract class LineDataEntity {
  List<Point<double>> realPoints;
  List<Point<double>> lineChartPoints;
  LineDataEntity({required this.realPoints, required this.lineChartPoints});
  double? getRealXByLineChartX(double? x) {
    if(x == null) {
      return null;
    }
    for((int, Point<double>) point in lineChartPoints.indexed) {
      if(point.$2.x == x) {
        return realPoints[point.$1].x;
      }
    }
  }
  List<double> getRealYByLineChartX(double? x) {
    if(x == null) {
      return [];
    }
    return lineChartPoints
        .indexed
        .where(
            (element) => element.$2.x == x)
        .toList()
        .map(
            (e) => realPoints[e.$1].y)
        .toList();
  }
  List<double> getLineChartYByLineChartX(double? x) {
    if(x == null) {
      return [];
    }
    return lineChartPoints
        .where(
            (element) => element.x == x)
        .map(
            (e) => e.y)
        .toList();
  }
}