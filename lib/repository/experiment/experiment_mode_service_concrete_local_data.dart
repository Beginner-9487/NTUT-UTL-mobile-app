import 'package:flutter/cupertino.dart';
import 'package:ntut_utl_mobile_app/repository/experiment/experiment_mode_service_interface.dart';
import 'package:ntut_utl_mobile_app/repository/local/local_data_service_interface.dart';
import 'package:ntut_utl_mobile_app/res/experiment_parameters.dart';

class ExperimentModeServiceLocalData extends ExperimentModeService {

  LocalDataService service;
  ExperimentModeServiceLocalData(this.service);

  @override
  Future<int> get mode async => await service.getData(service.key.EXPERIMENT, ExperimentMode.DEFAULT_EXPERIMENT_MODE);

  @override
  Future setMode(int value) async {
    debugPrint("setMode: $value");
    await service.setData(service.key.EXPERIMENT, value);
  }
}