import 'package:core/src/router/app_routes_module.dart';

abstract class AppRouter<T> {
  T get router;

  void registerModule(AppRoutesModule module);

  Future<R?> push<R>(String path);

  Future<R?> replace<R>(String path); 

  void pop<R>([R? result]);

  bool canPop();
}