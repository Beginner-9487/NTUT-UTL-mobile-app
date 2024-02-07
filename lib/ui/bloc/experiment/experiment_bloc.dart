import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ntut_utl_mobile_app/repository/experiment/experiment_mode_service_interface.dart';
import 'package:ntut_utl_mobile_app/res/experiment_parameters.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/experiment/experiment_event.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/experiment/experiment_state.dart';

class ExperimentBloc extends Bloc<ExperimentEvent, ExperimentState> {
  ExperimentModeService get experiment => ProjectParameters.experimentModeService;

  int mode = ExperimentMode.DEFAULT_EXPERIMENT_MODE;

  ExperimentBloc() : super(initialState) {
    on<ExperimentEventInit>((event, emit) {
      mapEventToState(event).first;
    });
    on<ExperimentEventChange>((event, emit) {
      mapEventToState(event).first;
    });
    debugPrint("ExperimentBloc: $mode");
  }

  @override
  static ExperimentState get initialState => ExperimentStateInit();

  @override
  Stream<ExperimentState> mapEventToState(ExperimentEvent event) async* {
    print("ExperimentBloc: mapEventToState: $event");
    if (event is ExperimentEventInit) {
      yield* _mapExperimentEventInitToState();
    } else if (event is ExperimentEventChange) {
      yield* _mapExperimentEventChangeToState(event);
    }
  }

  Stream<ExperimentState> _mapExperimentEventInitToState() async* {
    emit(ExperimentStateChanging());
    mode = await experiment.mode;
    debugPrint("_mapExperimentEventInitToState: $mode");
    emit(ExperimentStateInit());
  }

  Stream<ExperimentState> _mapExperimentEventChangeToState(ExperimentEventChange eventChange) async* {
    debugPrint("_mapExperimentEventChangeToState1: $mode");
    emit(ExperimentStateChanging());
    await experiment.setMode(eventChange.mode);
    debugPrint("_mapExperimentEventChangeToState2: $mode");
    emit(ExperimentStateInit());
  }
}
