import 'package:core/core.dart';
import 'package:products/src/data/datasources/products_remote_datasource.dart';
import 'package:products/src/data/models/product_model.dart';

final class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final AppClient _client;

  ProductsRemoteDataSourceImpl(this._client);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    const path = '/products';
    final data = await _client.get<Map<String, dynamic>>(path);
    
    final products = data?['products'] as List<dynamic>? ?? [];
    
    return products.map((e) => ProductModel.fromJson(e)).toList();
  }
}
