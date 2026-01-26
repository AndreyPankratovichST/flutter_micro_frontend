import 'package:client/src/data/dio_app_client.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';

const _baseUrl = 'https://dummyjson.com';

final class ClientModule implements DiModule {
  @override
  Future<void> build(Di di) async {
    final dio = Dio();
    dio.options.baseUrl = _baseUrl;

    di.registerLazySingleton<AppClient>(() => DioAppClient(dio));
  }
}
