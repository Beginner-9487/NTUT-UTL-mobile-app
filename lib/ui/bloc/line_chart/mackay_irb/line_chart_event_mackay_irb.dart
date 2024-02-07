import 'package:equatable/equatable.dart';

abstract class LineChartEventMackayIrb extends Equatable {
  const LineChartEventMackayIrb();

  @override
  List<Object?> get props => [];
}

class LineChartEventErrorMackayIrb extends LineChartEventMackayIrb {
  Object exception;

  LineChartEventErrorMackayIrb(this.exception);

  @override
  List<Object?> get props => [exception];

  @override
  String toString() {
    return 'LineChartEventErrorMackayIrb';
  }
}

class LineChartEventInitMackayIrb extends LineChartEventMackayIrb {
  @override
  String toString() {
    return 'LineChartEventInitMackayIrb';
  }
}

class LineChartEventRefreshMackayIrb extends LineChartEventMackayIrb {
  @override
  String toString() {
    return 'LineChartEventRefreshMackayIrb';
  }
}

class LineChartEventDisposeMackayIrb extends LineChartEventMackayIrb {
  @override
  String toString() {
    return 'LineChartEventDisposeMackayIrb';
  }
}

class LineChartEventSetLineChartXMackayIrb extends LineChartEventMackayIrb {
  double? x;

  LineChartEventSetLineChartXMackayIrb(this.x);

  @override
  List<Object?> get props => [x];

  @override
  String toString() {
    return 'LineChartEventSetLineChartXMackayIrb: $x';
  }
}