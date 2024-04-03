import 'package:logger/logger.dart';

class LoggerUtils {
  Logger logger = Logger();

  void logException(dynamic e) {
    logger.d('Exception', error: e);
  }

  void logError(String msg) {
    logger.e(msg);
  }

  void logWaring(String msg) {
    logger.w(msg);
  }

  void logInfo(String msg) {
    logger.i(msg);
  }
}
