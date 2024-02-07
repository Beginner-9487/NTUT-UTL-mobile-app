import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/experiment/experiment_bloc.dart';
import 'package:ntut_utl_mobile_app/ui/bloc/experiment/experiment_event.dart';

class SetExperimentModeView extends StatefulWidget {
  const SetExperimentModeView({Key? key}) : super(key: key);

  @override
  State<SetExperimentModeView> createState() => _SetExperimentModeViewState();
}

class _SetExperimentModeViewState extends State<SetExperimentModeView> {

  ExperimentBloc experimentBloc = ExperimentBloc();

  TextEditingController modeSettingsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Service App'),
        ),
        body: Column(
          children: [
            const Text("SetExperimentMode: "),
            TextField(
              controller: modeSettingsController,
              onChanged: (String str) {
                experimentBloc.add(ExperimentEventChange(int.parse(str)));
              }
            ),
          ],
        ),
      ),
    );
  }
}