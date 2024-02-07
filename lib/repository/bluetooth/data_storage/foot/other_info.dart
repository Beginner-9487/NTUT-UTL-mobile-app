class BodyPartEnum {
  static const int LEFT_FOOT = 0x0a;
  static const int RIGHT_FOOT = 0x0b;
  static const List<int> ALL_POSITION = [LEFT_FOOT, RIGHT_FOOT];
}

class MapFloatListEnum {
  // Origin
  static const int MagX = 0;
  static const int MagY = 1;
  static const int MagZ = 2;
  static const int Temperatures = 3;

  static const int ORIGIN_MAP_LENGTH = Temperatures + 1;
  static const int defaultNumberOfByte = 2;
  static const List<int> Once = [Temperatures];

  // Calculated
  static const int ShearForceX = 4;
  static const int ShearForceY = 5;
  static const int Pressures = 6;

  static const int CALCULATED_MAP_LENGTH = Pressures + 1 - ORIGIN_MAP_LENGTH;

  static const int ALL_MAP_LENGTH = ORIGIN_MAP_LENGTH + CALCULATED_MAP_LENGTH + 1;
}

class IMUFloatEnum {
  static const int AccX = 0;
  static const int AccY = 1;
  static const int AccZ = 2;
  static const int GyroX = 3;
  static const int GyroY = 4;
  static const int GyroZ = 5;
  static const int MagX = 6;
  static const int MagY = 7;
  static const int MagZ = 8;
  static const int Pitch = 9;
  static const int Roll = 10;
  static const int Yaw = 11;

  static const int IMU_LENGTH = Yaw + 1;
  static const int defaultNumberOfByte = 2;
  static const List<int> Triple = [];
}