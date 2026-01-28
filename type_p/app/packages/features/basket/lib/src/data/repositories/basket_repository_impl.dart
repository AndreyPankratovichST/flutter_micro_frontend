import 'package:basket/src/data/datasources/basket_local_datasource.dart';
import 'package:basket/src/data/mappers/product_mapper.dart';
import 'package:basket/src/domain/entities/product.dart';
import 'package:basket/src/domain/repositories/basket_repository.dart';

final class BasketRepositoryImpl implements BasketRepository {
  final BasketLocalDataSource _localDataSource;
  final ProductMapper _productMapper;

  const BasketRepositoryImpl(
    this._localDataSource,
    this._productMapper,
  );

  @override
  Future<List<Product>> fetchBasketProducts() async {
    final basket = await _localDataSource.fetchBasketProducts();
    return _productMapper.toEntities(basket);
  }
  
  @override
  Future<void> deleteFromBasket(Product product) async {
    final model = _productMapper.toModel(product);
    await _localDataSource.deleteFromBasket(model);
  }
}
