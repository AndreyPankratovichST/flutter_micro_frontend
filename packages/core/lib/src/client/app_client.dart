abstract class AppClient {
  Future<T?> get<T>(String path, [Map<String, String>? params]);

  Future<T?> post<T>(String path, [dynamic body]);
}
