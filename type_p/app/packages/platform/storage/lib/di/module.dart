import 'package:core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/src/data/shared_app_storage.dart';

final class StorageModule implements DiModule {
  @override
  Future<void> build(Di di) async {
    final prefs = await SharedPreferences.getInstance();

    di.registerLazySingleton(() => SharedAppStorage(prefs));
  }
}
