import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
);

class AppLogger {
  static void debug(String message) {
    logger.d(message);
  }

  static void error(String message) {
    logger.e(message);
  }

  static void info(String message) {
    logger.i(message);
  }
}
