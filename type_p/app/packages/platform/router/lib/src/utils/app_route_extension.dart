import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

extension AppRouteExt on AppRoute {
  RouteBase get toGoRoute {
    return GoRoute(
      path: path,
      builder: (_, state) {
        final params = {...state.pathParameters, ...state.uri.queryParameters};
        return builder(params);
      },
    );
  }
}
