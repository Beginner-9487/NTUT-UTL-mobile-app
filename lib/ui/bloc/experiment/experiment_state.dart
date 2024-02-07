import 'package:equatable/equatable.dart';

abstract class ExperimentState extends Equatable {
  const ExperimentState();

  @override
  List<Object?> get props => [];
}

class ExperimentStateInit extends ExperimentState {
  @override
  String toString() {
    return 'ExperimentStateInit';
  }
}

class ExperimentStateChanging extends ExperimentState {
  @override
  String toString() {
    return 'ExperimentStateChanging';
  }
}