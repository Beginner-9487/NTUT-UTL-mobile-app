import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MackayIrbType {
  static const int NONE = -1;
  static const int CORTISOL = 4;
  static const int LACTATE = 5;

  static String getTypeNameWithoutStr(int type) {
    switch(type) {
      case CORTISOL:
        return "cortisol";
      case LACTATE:
        return "lactate";
    }
    return "";
  }

  static String getTypeName(int type, AppLocalizations str) {
    switch(type) {
      case CORTISOL:
        return str.cortisol;
      case LACTATE:
        return str.lactate;
    }
    return "";
  }

  static String getXLabelName(int type, AppLocalizations str) {
    switch(type) {
      case CORTISOL:
      case LACTATE:
        return str.time;
    }
    return str.voltage;
  }

  static String getYLabelName(int type, AppLocalizations str) {
    return str.current;
  }

  static String getXUnitName(int type, AppLocalizations str) {
    switch(type) {
      case CORTISOL:
      case LACTATE:
        return "s";
    }
    return "mV";
  }

  static String getYUnitName(int type, AppLocalizations str) {
    return "uA";
  }
}