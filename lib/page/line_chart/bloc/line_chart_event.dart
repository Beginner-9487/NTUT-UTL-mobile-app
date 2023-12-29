import 'package:equatable/equatable.dart';

abstract class LineChartEvent extends Equatable {
  const LineChartEvent();

  @override
  List<Object?> get props => [];
}

class LineChartEventError extends LineChartEvent {
  Object exception;

  LineChartEventError(this.exception);

  @override
  List<Object?> get props => [exception];

  @override
  String toString() {
    return 'LoadHome';
  }
}