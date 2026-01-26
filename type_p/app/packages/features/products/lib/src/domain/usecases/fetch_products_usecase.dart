import 'package:core/core.dart';
import 'package:products/src/domain/entities/product.dart';
import 'package:products/src/domain/repositories/products_repository.dart';

class FetchProductsUseCase implements UseCase<List<Product>, Null> {
  final ProductsRepository _repository;

  FetchProductsUseCase(this._repository);

  @override
  Future<Result<List<Product>>> call([Null params]) async {
    try {
      return Result(result: await _repository.fetchProducts());
    } catch (e) {
      return Result(error: e);
    }
  }
}
