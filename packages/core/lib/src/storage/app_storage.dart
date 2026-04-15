abstract class AppStorage {
  Future<T?> get<T>(String key);

  Future<void> set<T>(String key, T value);

  Future<void> delete(String key);

  Future<void> clear();
}