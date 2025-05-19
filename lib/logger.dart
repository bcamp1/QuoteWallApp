import 'package:logging/logging.dart';

final log = Logger('AppLogger');

void initLogging() {
  Logger.root.level = Level.ALL; // Set global log level
  Logger.root.onRecord.listen((record) {
    print('[${record.level.name}] ${record.time}: ${record.message}');
  });
}
