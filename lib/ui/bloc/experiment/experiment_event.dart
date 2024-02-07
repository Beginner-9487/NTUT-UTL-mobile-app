import 'package:equatable/equatable.dart';

abstract class ExperimentEvent extends Equatable {
  const ExperimentEvent();

  @override
  List<Object?> get props => [];
}

class ExperimentEventInit extends ExperimentEvent {
  @override
  String toString() {
    return 'ExperimentEventInit';
  }
}

class ExperimentEventChange extends ExperimentEvent {
  int mode;

  ExperimentEventChange(this.mode);

  @override
  List<Object?> get props => [mode];

  @override
  String toString() {
    return 'ExperimentEventChange: $mode';
  }
}