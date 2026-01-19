typedef WidgetBuilder<Widget> = Widget Function(Map<String, String> params) ;

abstract class AppRoute<Widget> {
  String get path;

  WidgetBuilder<Widget> get builder;
}