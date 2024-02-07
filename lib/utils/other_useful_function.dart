import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class OtherUsefulFunction {
  OtherUsefulFunction._();

  static bool isLightMode(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.light;
  }

  //将被转义的字符变换原符号
  static String decodeString(String str) {
    return str
        .replaceAll('&amp;', '/')
        .replaceAll("&quot;", "\"")
        .replaceAll("&ldquo;", "“")
        .replaceAll("&rdquo;", "”")
        .replaceAll("<br>", "\n")
        .replaceAll("&gt;", ">")
        .replaceAll("&lt;", "<");
  }

  static Color _dataColorGenerator(isGray, double alpha, int dataIndex, int dataSize) {
    return HSVColor.fromAHSV(
      alpha,
      (dataSize>0) ? (255.0 * dataIndex/dataSize) : 0,
      isGray ? 0.0 : 1.0,
      1.0
    ).toColor();
  }

  static Color dataColorfulGenerator(double alpha, int dataIndex, int dataSize) {
    return _dataColorGenerator(false, alpha, dataIndex, dataSize);
  }

  static Color dataGrayscaleGenerator(double alpha, int dataIndex, int dataSize) {
    return _dataColorGenerator(true, alpha, dataIndex, dataSize);
  }

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}