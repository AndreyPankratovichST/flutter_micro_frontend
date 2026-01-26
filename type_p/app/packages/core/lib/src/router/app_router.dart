import 'package:core/src/router/app_router_module.dart';

abstract class AppRouter<T> {
  T get router;

  void registerModule(AppRouterModule module);

  Future<R?> push<R>(String path);

  Future<R?> replace<R>(String path); 

  void pop<R>([R? result]);

  bool canPop();
}