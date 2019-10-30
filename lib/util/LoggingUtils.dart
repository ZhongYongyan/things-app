import 'package:logging/logging.dart';

class LoggingConfig {
  static void config() {
    //日志配置
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print(
          '!!! ${rec.time} ${rec.level.name} ${rec.loggerName} ${rec.message}\n');
      if (rec.error != null) {
        print('!!! ${rec.error}\n');
      }
      if (rec.stackTrace != null) {
        print('!!! ${rec.stackTrace}\n');
      }
    });
  }
}

mixin LoggingMixin {
  Logger _log;

  Logger get log {
    if (_log == null) {
      String name = runtimeType.toString();
      _log = Logger(name);
    }
    return _log;
  }
}
