import 'package:core/core.dart';
import 'package:dio/dio.dart';

final class DioAppClient implements AppClient {
  final Dio _dio;

  DioAppClient(this._dio);

  @override
  Future<T?> get<T>(String path, [Map<String, String>? params]) async {
    final response = await _dio.get<T>(path, queryParameters: params);
    return response.data;
  }

  @override
  Future<T?> post<T>(String path, [body]) async {
    final response = await _dio.post<T>(path, data: body);
    return response.data;
  }
}