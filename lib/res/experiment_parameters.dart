class ExperimentTargetBLEUUID {
  static String get MackaySendUUID => "0000fff3-0000-1000-8000-00805f9b34fb";
  static String get MackaySubscribeUUID => "0000fff6-0000-1000-8000-00805f9b34fb";
}

class ExperimentTargetBLECommand {
  static List<int> get MackayStart => [0x60, 0x01];
}

class ExperimentMode {
  static const int MackayIRB = 0;
  static const int Foot = 1;
  static const int DEFAULT_EXPERIMENT_MODE = ExperimentMode.MackayIRB;
}