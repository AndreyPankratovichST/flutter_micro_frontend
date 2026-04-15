import 'package:core/core.dart';
import 'package:talker/talker.dart';

final class TalkerAppLogger implements AppLogger {
  final Talker _talker;

  const TalkerAppLogger(this._talker);

  @override
  void d(String message) {
    _talker.debug(message);
  }

  @override
  void e(Error e) {
    _talker.error(null, e, e.stackTrace);
  }

  @override
  void i(String message) {
    _talker.info(message);
  }

  @override
  void w(String message) {
    _talker.warning(message);
  }
}