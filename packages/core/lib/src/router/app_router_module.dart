typedef WidgetBuilder<Widget> = Widget Function(Map<String, String> params);

class AppRoute<Widget> {
  final String path;
  final WidgetBuilder<Widget> builder;

  AppRoute({required this.path, required this.builder});
}

abstract class AppRouterModule {
  List<AppRoute> get routes;
}
