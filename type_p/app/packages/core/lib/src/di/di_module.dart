import 'package:core/src/di/di.dart';

abstract class DiModule {
  Future<void> build(Di di);
}
