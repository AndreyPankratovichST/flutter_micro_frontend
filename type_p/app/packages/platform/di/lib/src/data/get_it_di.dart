import 'package:core/core.dart';
import 'package:get_it/get_it.dart';

final GetIt _getIt = GetIt.I;

final class GetItDi implements Di {
  GetItDi() {
    di = this;
  }
  
  @override
  void registerLazy<T extends Object>(LazyFactory<T> factory) {
    _getIt.registerFactory<T>(factory);
  }

  @override
  void registerLazySingleton<T extends Object>(LazyFactory<T> factory) {
    _getIt.registerLazySingleton<T>(factory);
  }

  @override
  void registerSingleton<T extends Object>(T value) {
    _getIt.registerSingleton<T>(value);
  }

  @override
  T get<T extends Object>() {
    return _getIt.get<T>();
  }
}
