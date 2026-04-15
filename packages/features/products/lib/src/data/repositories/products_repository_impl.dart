import 'package:products/src/data/datasources/products_local_datasource.dart';
import 'package:products/src/data/datasources/products_remote_datasource.dart';
import 'package:products/src/data/mappers/product_mapper.dart';
import 'package:products/src/domain/entities/product.dart';
import 'package:products/src/domain/repositories/products_repository.dart';

final class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;
  final ProductsLocalDataSource _localDataSource;
  final ProductMapper _productMapper;

  const ProductsRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._productMapper,
  );

  @override
  Future<List<Product>> fetchProducts() async {
    final products = await _localDataSource.fetchProducts();
    if (products.isNotEmpty) {
      return _productMapper.toEntities(products);
    }

    final remoteProducts = await _remoteDataSource.fetchProducts();
    if (remoteProducts.isNotEmpty) {
      await _localDataSource.saveProducts(remoteProducts);
    }
    return  _productMapper.toEntities(remoteProducts);
  }
  
  @override
  Future<void> addToBasket(Product product) async {
    final model = _productMapper.toModel(product);
    await _localDataSource.addToBasket(model);
  }
  
  @override
  Future<int> getProductsBasketCount() {
    return _localDataSource.getProductsBasketCount();
  }
}
