import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ntut_utl_mobile_app/repository/line_chart/line_chart_storage_concrete_mackay_irb.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';

import 'line_chart_state_mackay_irb.dart';
import 'line_chart_event_mackay_irb.dart';

class LineChartBlocMackayIrb extends Bloc<LineChartEventMackayIrb, LineChartStateMackayIrb> {
  LineChartStorageMackayIRB get lineChartStorageMackayIRB => ProjectParameters.lineChartStorageMackayIRB;
  late StreamSubscription<List<LineDataEntityMackayIRB>> lineDataUpdateSubscription;
  late StreamSubscription<void> onXChangeSubscription;

  List<LineDataEntityMackayIRB> get lineChartData => lineChartStorageMackayIRB.lineData;

  double? get lineChartX => lineChartStorageMackayIRB.lineChartX;

  LineChartBlocMackayIrb() : super(initialState) {
    on<LineChartEventErrorMackayIrb>((event, emit) {
      mapEventToState(event).first;
    });
    on<LineChartEventInitMackayIrb>((event, emit) {
      mapEventToState(event).first;
    });
    on<LineChartEventRefreshMackayIrb>((event, emit) {
      mapEventToState(event).first;
    });
    on<LineChartEventDisposeMackayIrb>((event, emit) {
      mapEventToState(event).first;
    });
    on<LineChartEventSetLineChartXMackayIrb>((event, emit) {
      mapEventToState(event).first;
    });

    lineDataUpdateSubscription = lineChartStorageMackayIRB.onLineDataUpdateSubscription((data) {
      _refreshUI();
    });

    onXChangeSubscription = lineChartStorageMackayIRB.onLineChartXChangeSubscription(() {
      // debugPrint("lineChartX dashboard: $lineChartX");
      _refreshUI();
    });
  }

  @override
  static LineChartStateInitMackayIrb get initialState => LineChartStateInitMackayIrb();

  @override
  Stream<LineChartStateMackayIrb> mapEventToState(LineChartEventMackayIrb event) async* {
    print("LineChartBloc: mapEventToState: $event");
    if (event is LineChartEventErrorMackayIrb) {
      yield* _mapErrorToState();
    } else if (event is LineChartEventInitMackayIrb) {
      yield* _mapInitToState();
    } else if (event is LineChartEventRefreshMackayIrb) {
      yield* _mapRefreshToState();
    } else if (event is LineChartEventDisposeMackayIrb) {
      yield* _mapDisposeToState();
    } else if (event is LineChartEventSetLineChartXMackayIrb) {
      yield* _mapSetLineChartXToState(event);
    }
  }

  _refreshUI() {
    emit(LineChartStateRefreshingMackayIrb());
    emit(LineChartStateInitMackayIrb());
  }

  Stream<LineChartStateMackayIrb> _mapInitToState() async* {
    _refreshUI();
  }

  Stream<LineChartStateMackayIrb> _mapRefreshToState() async* {
    _refreshUI();
  }

  Stream<LineChartStateMackayIrb> _mapErrorToState() async* {
    _refreshUI();
  }

  Stream<LineChartStateMackayIrb> _mapDisposeToState() async* {
    lineDataUpdateSubscription.cancel();
    _refreshUI();
  }

  Stream<LineChartStateMackayIrb> _mapSetLineChartXToState(LineChartEventSetLineChartXMackayIrb event) async* {
    lineChartStorageMackayIRB.setLineChartX(event.x);
  }
}
