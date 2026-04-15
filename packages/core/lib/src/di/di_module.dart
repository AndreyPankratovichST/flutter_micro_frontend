import 'di.dart';

abstract class DiModule {
  Future<void> build(Di di);
}
