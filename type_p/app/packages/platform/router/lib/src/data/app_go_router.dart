import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:router/src/utils/app_route_extension.dart';

final class AppGoRouter implements AppRouter {
  GoRouter? _router;
  final List<RouteBase> _routes = [];

  @override
  get router {
    if (_router != null) {
      return _router;
    }
    _router = GoRouter(routes: _routes, debugLogDiagnostics: kDebugMode);
    return _router;
  }

  @override
  void registerModule(AppRouterModule module) {
    _routes.addAll(module.routes.map((e) => e.toGoRoute));
  }

  void _hasInitCheck() {
    if (_router == null) {
      throw Exception('Router not initialization');
    }
  }

  @override
  bool canPop() {
    _hasInitCheck();
    return _router!.canPop();
  }

  @override
  void pop<R>([R? result]) {
    _hasInitCheck();
    return _router!.pop<R>(result);
  }

  @override
  Future<R?> push<R>(String path) {
    _hasInitCheck();
    return _router!.push<R>(path);
  }

  @override
  Future<R?> replace<R>(String path) {
    _hasInitCheck();
    return _router!.replace(path);
  }
}
