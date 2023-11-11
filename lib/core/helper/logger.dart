import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class Log {
  static Logger? _logger;

  static Logger get instance {
    if (_logger != null) {
      return _logger!;
    } else {
      throw StateError('Log not initialized');
    }
  }

  static void init() {
    _logger ??= Logger(printer: PrettyPrinter(colors: true), level: Level.debug);
  }

  static void info(String message) {
    instance.d(message);
  }
}
