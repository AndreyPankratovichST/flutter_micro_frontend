import 'package:basket/src/presentation/pages/basket_page.dart';
import 'package:core/core.dart';

const basketPath = '/basket';

final class BasketRouterModule implements AppRouterModule {
  @override
  List<AppRoute> get routes => [
    AppRoute(path: basketPath, builder: (_) => BasketPage()),
  ];
}
