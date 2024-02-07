import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ntut_utl_mobile_app/ui/navigation_home_screen.dart';
import 'package:ntut_utl_mobile_app/utils/foreground_background_service.dart';

import 'res/bloc_observer.dart';
import 'res/project_parameters.dart';
import 'res/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await initializeService();
  Bloc.observer = GlobalBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: AppColors.theme_color,
      ),
      routes: ProjectParameters.routes,
      title: "str.appName",
      home: const NavigationHomeScreen(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
