import 'package:core/core.dart';
import 'package:products/src/data/datasources/products_local_datasource.dart';
import 'package:products/src/data/models/product_model.dart';

const _productsKey = 'products';
const _basketKey = 'basket';

final class ProductsLocalDataSourceImpl implements ProductsLocalDataSource {
  final AppStorage _storage;

  ProductsLocalDataSourceImpl(this._storage);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final data = await _storage.get<List<dynamic>>(_productsKey);

    return data?.map((e) => ProductModel.fromJson(e)).toList() ?? [];
  }
  
  @override
  Future<void> saveProducts(List<ProductModel> products) async {
    await _storage.set(_productsKey, products);
  }
  
  @override
  Future<void> addToBasket(ProductModel model) async {
    final data = await _storage.get<List<dynamic>>(_basketKey);
    final updatedData = (data ?? [])..add(model.toJson());
    await _storage.set(_basketKey, updatedData);
  }
  
  @override
  Future<int> getProductsBasketCount() async {
    final data = await _storage.get<List<dynamic>>(_basketKey);
    return data?.length ?? 0;
  }
}
