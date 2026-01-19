import 'package:core/core.dart';
import 'package:products/src/domain/entities/product.dart';
import 'package:products/src/domain/repositories/products_repository.dart';

class FetchProductsUseCase implements UseCase<List<Product>, void> {
  final ProductsRepository _repository;

  FetchProductsUseCase(this._repository);

  @override
  Future<List<Product>> call(void params) {
    return _repository.fetchProducts();
  }
}
