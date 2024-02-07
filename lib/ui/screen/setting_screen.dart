import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ntut_utl_mobile_app/res/project_parameters.dart';
import 'package:ntut_utl_mobile_app/ui/view/set_experiment_mode_view.dart';
import 'package:ntut_utl_mobile_app/ui/view/set_foreground_background_service_view.dart';

class SettingsScreen extends StatelessWidget with StatelessWidgetWithResStrings {
  static get ROUTER_NAME => '/SettingsScreen';

  SettingsScreen({super.key});

  @override
  Widget buildWithContext(BuildContext context) {
    return const SetForegroundBackgroundServiceView();
    // return SetExperimentModeView();
    // return ListView(
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   children: const [
    //     SetExperimentModeView(),
    //     // const SetForegroundBackgroundServiceView(),
    //   ],
    // );
    // return SizedBox(
    //   height: 500,
    //   width: 300,
    //   child: const Column(
    //     children: [
    //       SetExperimentModeView(),
    //       SetForegroundBackgroundServiceView(),
    //     ],
    //   ),
    // );
    // return const Column(
    //   children: [
    //     SetExperimentModeView(),
    //     SetForegroundBackgroundServiceView(),
    //   ],
    // );
  }
}