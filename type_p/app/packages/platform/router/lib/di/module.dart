import 'package:core/core.dart';
import 'package:router/src/data/app_go_router.dart';

final class RouterModule implements DiModule {
  @override
  Future<void> build(Di di) async {
    di.registerLazySingleton<AppRouter>(() => AppGoRouter());
  }
}
