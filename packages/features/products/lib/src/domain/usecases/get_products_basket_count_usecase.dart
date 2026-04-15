import 'package:core/core.dart';
import 'package:products/src/domain/repositories/products_repository.dart';

class GetProductsBasketCountUseCase implements UseCase<int, Null> {
  final ProductsRepository _repository;

  GetProductsBasketCountUseCase(this._repository);

  @override
  Future<Result<int>> call([Null params]) async {
    try {
      return Result(result: await _repository.getProductsBasketCount());
    } catch (e) {
      return Result(error: e);
    }
  }
}
