import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import 'project_parameters.dart';

class GlobalBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    if (ProjectParameters.blocDebug) {
      debugPrint('Bloc-onCreate : $bloc');
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (ProjectParameters.blocDebug) {
      debugPrint('Bloc-onEvent : $event');
    }
  }

  @override
  void onChange(BlocBase bloc, Object? change) {
    if (ProjectParameters.blocDebug) {
      debugPrint('Bloc-onChange : $change');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (ProjectParameters.blocDebug) {
      debugPrint('Bloc-onTransition : $transition');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (ProjectParameters.blocDebug) {
      debugPrint('Bloc-onError : $error');
      debugPrint('Bloc-onError-stackTrace : $stackTrace');
    }
  }

  @override
  void onClose(BlocBase bloc) {
    if (ProjectParameters.blocDebug) {
      debugPrint('Bloc-onClose : $bloc');
    }
  }
}