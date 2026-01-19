typedef LazyFactory<T> = T Function();

late Di di;

abstract class Di {
  void registerLazy<T extends Object>(LazyFactory<T> factory);

  void registerSingleton<T extends Object>(T value);

  void registerLazySingleton<T extends Object>(LazyFactory<T> factory);

  T get<T extends Object>();
}
