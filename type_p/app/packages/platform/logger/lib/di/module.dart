import 'package:core/core.dart';
import 'package:logger/src/data/talker_logger.dart';
import 'package:talker/talker.dart';

final class LoggerModule implements DiModule {
  @override
  Future<void> build(Di di) async {
    di.registerLazySingleton<AppLogger>(
      () => TalkerAppLogger(Talker(logger: TalkerLogger())),
    );
  }
}
