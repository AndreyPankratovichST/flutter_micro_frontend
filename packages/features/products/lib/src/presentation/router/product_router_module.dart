import 'package:core/core.dart';
import 'package:products/src/presentation/pages/products_page.dart';

const productsPath = '/';

final class ProductRouterModule implements AppRouterModule {
  @override
  List<AppRoute> get routes => [
    AppRoute(path: productsPath, builder: (_) => ProductsPage()),
  ];
}
